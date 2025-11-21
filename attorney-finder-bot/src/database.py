"""
Database module for storing and retrieving attorney information.
"""
import sqlite3
from typing import List, Dict, Optional
from datetime import datetime


class AttorneyDatabase:
    """Manages SQLite database for attorney information."""

    def __init__(self, db_path: str = "attorneys.db"):
        """Initialize database connection and create tables if needed."""
        self.db_path = db_path
        self.init_database()

    def init_database(self):
        """Create database tables if they don't exist."""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS attorneys (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                phone TEXT,
                email TEXT,
                website TEXT,
                address TEXT,
                city TEXT,
                state TEXT,
                zip_code TEXT,
                practice_areas TEXT,
                source_url TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        cursor.execute('''
            CREATE INDEX IF NOT EXISTS idx_city ON attorneys(city)
        ''')

        cursor.execute('''
            CREATE INDEX IF NOT EXISTS idx_zip ON attorneys(zip_code)
        ''')

        cursor.execute('''
            CREATE INDEX IF NOT EXISTS idx_name ON attorneys(name)
        ''')

        conn.commit()
        conn.close()

    def add_attorney(self, attorney_data: Dict) -> int:
        """
        Add a new attorney to the database.

        Args:
            attorney_data: Dictionary containing attorney information

        Returns:
            ID of the inserted attorney
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO attorneys (
                name, phone, email, website, address, city, state,
                zip_code, practice_areas, source_url, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            attorney_data.get('name'),
            attorney_data.get('phone'),
            attorney_data.get('email'),
            attorney_data.get('website'),
            attorney_data.get('address'),
            attorney_data.get('city'),
            attorney_data.get('state'),
            attorney_data.get('zip_code'),
            attorney_data.get('practice_areas'),
            attorney_data.get('source_url'),
            datetime.now()
        ))

        attorney_id = cursor.lastrowid
        conn.commit()
        conn.close()

        return attorney_id

    def search_attorneys(
        self,
        city: Optional[str] = None,
        zip_code: Optional[str] = None,
        practice_area: Optional[str] = None,
        limit: int = 50
    ) -> List[Dict]:
        """
        Search for attorneys by location and practice area.

        Args:
            city: City name
            zip_code: ZIP code
            practice_area: Practice area keyword
            limit: Maximum number of results

        Returns:
            List of attorney dictionaries
        """
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()

        query = "SELECT * FROM attorneys WHERE 1=1"
        params = []

        if city:
            query += " AND LOWER(city) LIKE ?"
            params.append(f"%{city.lower()}%")

        if zip_code:
            query += " AND zip_code LIKE ?"
            params.append(f"%{zip_code}%")

        if practice_area:
            query += " AND LOWER(practice_areas) LIKE ?"
            params.append(f"%{practice_area.lower()}%")

        query += " ORDER BY created_at DESC LIMIT ?"
        params.append(limit)

        cursor.execute(query, params)
        rows = cursor.fetchall()

        attorneys = [dict(row) for row in rows]
        conn.close()

        return attorneys

    def get_attorney_by_id(self, attorney_id: int) -> Optional[Dict]:
        """Get attorney by ID."""
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()

        cursor.execute("SELECT * FROM attorneys WHERE id = ?", (attorney_id,))
        row = cursor.fetchone()

        conn.close()

        return dict(row) if row else None

    def get_stats(self) -> Dict:
        """Get database statistics."""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()

        cursor.execute("SELECT COUNT(*) FROM attorneys")
        total = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(DISTINCT city) FROM attorneys WHERE city IS NOT NULL")
        cities = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(DISTINCT state) FROM attorneys WHERE state IS NOT NULL")
        states = cursor.fetchone()[0]

        conn.close()

        return {
            'total_attorneys': total,
            'unique_cities': cities,
            'unique_states': states
        }
