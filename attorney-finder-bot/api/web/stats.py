"""
Web API for database statistics.
"""
import os
import sys
import json

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../..'))

from src.database import AttorneyDatabase

db = AttorneyDatabase(os.getenv('DATABASE_PATH', '/tmp/attorneys.db'))


def handler(request):
    """
    Get database statistics.

    GET /api/web/stats
    """
    if request.method != 'GET':
        return {
            'statusCode': 405,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': 'Method not allowed'})
        }

    try:
        stats = db.get_stats()

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'success': True,
                'stats': stats
            })
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({
                'success': False,
                'error': str(e)
            })
        }
