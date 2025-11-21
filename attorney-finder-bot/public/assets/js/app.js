// Attorney Finder - Web App JavaScript

// State
let currentUser = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
    loadStats();
});

// Initialize app
function initializeApp() {
    // Check for existing session
    const savedUser = localStorage.getItem('telegram_user');
    if (savedUser) {
        try {
            currentUser = JSON.parse(savedUser);
            showApp();
        } catch (e) {
            console.error('Error loading saved user:', e);
        }
    }

    // Setup event listeners
    document.getElementById('search-form')?.addEventListener('submit', handleSearch);
    document.getElementById('logout-btn')?.addEventListener('click', handleLogout);
}

// Telegram authentication callback
function onTelegramAuth(user) {
    console.log('Telegram auth:', user);

    // Verify with backend
    fetch('/api/web/auth', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(user)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            currentUser = data.user;
            localStorage.setItem('telegram_user', JSON.stringify(currentUser));
            showApp();
        } else {
            alert('Authentication failed: ' + data.error);
        }
    })
    .catch(error => {
        console.error('Auth error:', error);
        alert('Authentication error. Please try again.');
    });
}

// Show main app
function showApp() {
    document.getElementById('login-section').classList.add('hidden');
    document.getElementById('app-section').classList.remove('hidden');

    // Display user info
    if (currentUser) {
        document.getElementById('user-name').textContent =
            `${currentUser.first_name || ''} ${currentUser.last_name || ''}`.trim() ||
            currentUser.username ||
            'User';

        if (currentUser.photo_url) {
            document.getElementById('user-photo').src = currentUser.photo_url;
        }
    }

    // Load initial data
    loadStats();
}

// Handle logout
function handleLogout() {
    currentUser = null;
    localStorage.removeItem('telegram_user');
    document.getElementById('app-section').classList.add('hidden');
    document.getElementById('login-section').classList.remove('hidden');
    document.getElementById('results-section').classList.add('hidden');
}

// Load statistics
function loadStats() {
    fetch('/api/web/stats')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const stats = data.stats;
                document.getElementById('stat-attorneys').textContent =
                    stats.total_attorneys || 0;
                document.getElementById('stat-cities').textContent =
                    stats.unique_cities || 0;
                document.getElementById('stat-states').textContent =
                    stats.unique_states || 0;
            }
        })
        .catch(error => {
            console.error('Error loading stats:', error);
        });
}

// Handle search form submission
function handleSearch(e) {
    e.preventDefault();

    const zip = document.getElementById('search-zip').value.trim();
    const city = document.getElementById('search-city').value.trim();
    const practice = document.getElementById('search-practice').value;

    if (!zip && !city && !practice) {
        alert('Please enter at least one search criteria');
        return;
    }

    // Build query string
    const params = new URLSearchParams();
    if (zip) params.append('zip', zip);
    if (city) params.append('city', city);
    if (practice) params.append('practice', practice);

    // Show loading
    const resultsSection = document.getElementById('results-section');
    const resultsList = document.getElementById('results-list');
    resultsSection.classList.remove('hidden');
    resultsList.innerHTML = '<div class="loading"></div>';

    // Fetch results
    fetch(`/api/web/search?${params.toString()}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                displayResults(data.results);
            } else {
                resultsList.innerHTML = `<div class="empty-state">Error: ${data.error}</div>`;
            }
        })
        .catch(error => {
            console.error('Search error:', error);
            resultsList.innerHTML = '<div class="empty-state">Search failed. Please try again.</div>';
        });
}

// Display search results
function displayResults(results) {
    const resultsSection = document.getElementById('results-section');
    const resultsCount = document.getElementById('results-count');
    const resultsList = document.getElementById('results-list');

    if (!results || results.length === 0) {
        resultsCount.textContent = 'No attorneys found';
        resultsCount.style.background = '#999';
        resultsList.innerHTML = `
            <div class="empty-state">
                <p>No attorneys match your search criteria.</p>
                <p>Try different search terms or add attorneys via the Telegram bot.</p>
            </div>
        `;
        return;
    }

    resultsCount.textContent = `Found ${results.length} attorney${results.length !== 1 ? 's' : ''}`;
    resultsCount.style.background = 'var(--success-color)';

    resultsList.innerHTML = results.map((attorney, index) => `
        <div class="result-card">
            <h3>${index + 1}. ${attorney.name || 'Unknown'}</h3>
            <div class="result-info">
                ${attorney.phone ? `
                    <div>
                        <strong>📱 Phone:</strong>
                        <span class="result-phone">${attorney.phone}</span>
                    </div>
                ` : ''}

                ${attorney.email ? `
                    <div>
                        <strong>📧 Email:</strong>
                        <a href="mailto:${attorney.email}">${attorney.email}</a>
                    </div>
                ` : ''}

                ${attorney.address || attorney.city ? `
                    <div>
                        <strong>📍 Location:</strong>
                        <span>
                            ${attorney.address || ''}
                            ${attorney.city ? attorney.city + ', ' : ''}
                            ${attorney.state || ''}
                            ${attorney.zip_code || ''}
                        </span>
                    </div>
                ` : ''}

                ${attorney.practice_areas ? `
                    <div>
                        <strong>⚖️ Practice:</strong>
                        <span>${attorney.practice_areas}</span>
                    </div>
                ` : ''}

                ${attorney.website && attorney.website !== 'N/A' ? `
                    <div>
                        <strong>🌐 Website:</strong>
                        <a href="${attorney.website}" target="_blank" rel="noopener">${attorney.website}</a>
                    </div>
                ` : ''}
            </div>
        </div>
    `).join('');
}

// Make onTelegramAuth available globally
window.onTelegramAuth = onTelegramAuth;
