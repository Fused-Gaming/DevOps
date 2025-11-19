"""
Web API for attorney search.
"""
import os
import sys
import json

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../..'))

from src.database import AttorneyDatabase

# Initialize database
db = AttorneyDatabase(os.getenv('DATABASE_PATH', '/tmp/attorneys.db'))


def handler(request):
    """
    Handle search requests from web UI.

    GET /api/web/search?q=query&city=city&zip=zip&practice=area
    """
    if request.method != 'GET':
        return {
            'statusCode': 405,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': 'Method not allowed'})
        }

    try:
        # Get query parameters
        params = request.args

        city = params.get('city')
        zip_code = params.get('zip')
        practice_area = params.get('practice')
        limit = int(params.get('limit', 50))

        # Search database
        results = db.search_attorneys(
            city=city,
            zip_code=zip_code,
            practice_area=practice_area,
            limit=limit
        )

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'success': True,
                'count': len(results),
                'results': results
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
