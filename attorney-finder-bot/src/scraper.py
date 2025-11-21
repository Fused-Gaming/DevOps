"""
Web scraper for extracting attorney information from various sources.
"""
import re
import requests
from bs4 import BeautifulSoup
from typing import List, Dict, Optional
import phonenumbers
from urllib.parse import urljoin, urlparse
import time


class AttorneyScraper:
    """Scrapes attorney information from web pages."""

    def __init__(self, delay: float = 2.0):
        """
        Initialize scraper.

        Args:
            delay: Delay between requests in seconds (be respectful)
        """
        self.delay = delay
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

    def scrape_url(self, url: str) -> List[Dict]:
        """
        Scrape attorney information from a given URL.

        Args:
            url: URL to scrape

        Returns:
            List of attorney data dictionaries
        """
        try:
            response = self.session.get(url, timeout=10)
            response.raise_for_status()

            soup = BeautifulSoup(response.content, 'lxml')
            attorneys = []

            # Extract attorney data
            attorney_data = self._extract_attorney_data(soup, url)
            if attorney_data:
                attorneys.append(attorney_data)

            # Respect the server
            time.sleep(self.delay)

            return attorneys

        except Exception as e:
            print(f"Error scraping {url}: {str(e)}")
            return []

    def _extract_attorney_data(self, soup: BeautifulSoup, source_url: str) -> Optional[Dict]:
        """
        Extract attorney data from BeautifulSoup object.

        Args:
            soup: BeautifulSoup parsed HTML
            source_url: Original URL

        Returns:
            Dictionary with attorney data or None
        """
        data = {
            'source_url': source_url,
            'name': None,
            'phone': None,
            'email': None,
            'website': None,
            'address': None,
            'city': None,
            'state': None,
            'zip_code': None,
            'practice_areas': None
        }

        # Extract name
        name = self._extract_name(soup)
        if name:
            data['name'] = name

        # Extract phone numbers
        phones = self._extract_phone_numbers(soup)
        if phones:
            data['phone'] = ', '.join(phones)

        # Extract email
        email = self._extract_email(soup)
        if email:
            data['email'] = email

        # Extract address components
        address_data = self._extract_address(soup)
        data.update(address_data)

        # Extract practice areas
        practice_areas = self._extract_practice_areas(soup)
        if practice_areas:
            data['practice_areas'] = ', '.join(practice_areas)

        # Extract website
        website = self._extract_website(soup, source_url)
        if website:
            data['website'] = website

        return data if data['name'] or data['phone'] else None

    def _extract_name(self, soup: BeautifulSoup) -> Optional[str]:
        """Extract attorney name from page."""
        # Try common selectors for attorney names
        selectors = [
            'h1.attorney-name',
            'h1.profile-name',
            '.attorney-info h1',
            'h1',
            '.profile-header h1',
            '[itemprop="name"]',
            '.lawyer-name'
        ]

        for selector in selectors:
            elem = soup.select_one(selector)
            if elem and elem.get_text(strip=True):
                name = elem.get_text(strip=True)
                # Basic validation - name shouldn't be too long
                if len(name) < 100 and not name.lower().startswith(('search', 'find', 'contact')):
                    return name

        return None

    def _extract_phone_numbers(self, soup: BeautifulSoup) -> List[str]:
        """Extract and validate phone numbers from page."""
        phones = set()

        # Get all text content
        text_content = soup.get_text()

        # Find all phone number patterns
        phone_patterns = [
            r'\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}',  # (123) 456-7890 or variations
            r'\d{3}[-.\s]?\d{3}[-.\s]?\d{4}',        # 123-456-7890 or variations
            r'\+1[-.\s]?\d{3}[-.\s]?\d{3}[-.\s]?\d{4}',  # +1-123-456-7890
        ]

        for pattern in phone_patterns:
            matches = re.findall(pattern, text_content)
            for match in matches:
                try:
                    # Parse and validate phone number
                    parsed = phonenumbers.parse(match, "US")
                    if phonenumbers.is_valid_number(parsed):
                        formatted = phonenumbers.format_number(
                            parsed,
                            phonenumbers.PhoneNumberFormat.NATIONAL
                        )
                        phones.add(formatted)
                except:
                    continue

        return list(phones)[:5]  # Limit to first 5 unique numbers

    def _extract_email(self, soup: BeautifulSoup) -> Optional[str]:
        """Extract email address from page."""
        # Find mailto links
        mailto_links = soup.find_all('a', href=re.compile(r'^mailto:'))
        if mailto_links:
            email = mailto_links[0]['href'].replace('mailto:', '').strip()
            if self._is_valid_email(email):
                return email

        # Find email patterns in text
        text_content = soup.get_text()
        email_pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
        matches = re.findall(email_pattern, text_content)

        for email in matches:
            if self._is_valid_email(email):
                return email

        return None

    def _is_valid_email(self, email: str) -> bool:
        """Validate email address."""
        # Basic validation - avoid common false positives
        invalid_domains = ['example.com', 'test.com', 'email.com']
        if any(domain in email.lower() for domain in invalid_domains):
            return False

        pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
        return bool(re.match(pattern, email))

    def _extract_address(self, soup: BeautifulSoup) -> Dict:
        """Extract address components from page."""
        data = {
            'address': None,
            'city': None,
            'state': None,
            'zip_code': None
        }

        # Try schema.org markup first
        address_elem = soup.find(attrs={"itemtype": re.compile(r"PostalAddress")})
        if address_elem:
            street = address_elem.find(attrs={"itemprop": "streetAddress"})
            city = address_elem.find(attrs={"itemprop": "addressLocality"})
            state = address_elem.find(attrs={"itemprop": "addressRegion"})
            zip_code = address_elem.find(attrs={"itemprop": "postalCode"})

            if street:
                data['address'] = street.get_text(strip=True)
            if city:
                data['city'] = city.get_text(strip=True)
            if state:
                data['state'] = state.get_text(strip=True)
            if zip_code:
                data['zip_code'] = zip_code.get_text(strip=True)

            return data

        # Look for address in common class names
        address_selectors = [
            '.address',
            '.location',
            '.contact-info',
            '[itemprop="address"]'
        ]

        for selector in address_selectors:
            elem = soup.select_one(selector)
            if elem:
                address_text = elem.get_text(strip=True)
                # Try to parse address components
                parsed = self._parse_address_text(address_text)
                if parsed:
                    return parsed

        return data

    def _parse_address_text(self, text: str) -> Optional[Dict]:
        """Parse address text into components."""
        # Look for ZIP code
        zip_match = re.search(r'\b\d{5}(?:-\d{4})?\b', text)
        zip_code = zip_match.group() if zip_match else None

        # Look for state (2-letter code)
        state_match = re.search(r'\b([A-Z]{2})\b', text)
        state = state_match.group(1) if state_match else None

        # City is typically before state
        city = None
        if state_match:
            city_match = re.search(r',\s*([^,]+)\s+' + re.escape(state), text)
            if city_match:
                city = city_match.group(1).strip()

        return {
            'address': text,
            'city': city,
            'state': state,
            'zip_code': zip_code
        }

    def _extract_practice_areas(self, soup: BeautifulSoup) -> List[str]:
        """Extract practice areas from page."""
        practice_areas = set()

        # Common practice area keywords
        keywords = [
            'criminal', 'family', 'divorce', 'personal injury', 'dui', 'dwi',
            'immigration', 'bankruptcy', 'estate planning', 'real estate',
            'business', 'corporate', 'employment', 'civil', 'litigation',
            'medical malpractice', 'workers compensation', 'tax', 'intellectual property'
        ]

        # Look in specific sections
        practice_selectors = [
            '.practice-areas',
            '.areas-of-practice',
            '.specialties',
            '[class*="practice"]'
        ]

        for selector in practice_selectors:
            elems = soup.select(selector)
            for elem in elems:
                text = elem.get_text().lower()
                for keyword in keywords:
                    if keyword in text:
                        practice_areas.add(keyword.title())

        # Also check meta description and page title
        meta_desc = soup.find('meta', attrs={'name': 'description'})
        if meta_desc and meta_desc.get('content'):
            text = meta_desc['content'].lower()
            for keyword in keywords:
                if keyword in text:
                    practice_areas.add(keyword.title())

        return list(practice_areas)

    def _extract_website(self, soup: BeautifulSoup, source_url: str) -> Optional[str]:
        """Extract website URL."""
        # Parse the source URL
        parsed = urlparse(source_url)
        base_url = f"{parsed.scheme}://{parsed.netloc}"

        # Look for website links
        for link in soup.find_all('a', href=True):
            href = link['href']
            text = link.get_text(strip=True).lower()

            if 'website' in text or 'visit' in text:
                full_url = urljoin(source_url, href)
                if urlparse(full_url).netloc != parsed.netloc:
                    return full_url

        return base_url
