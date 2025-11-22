"""
Telegram Web App authentication.
"""
import os
import sys
import json
import hashlib
import hmac

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../..'))

BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN', '')


def verify_telegram_auth(auth_data):
    """
    Verify Telegram Web App authentication data.

    Args:
        auth_data: Dict with Telegram auth data

    Returns:
        bool: True if valid, False otherwise
    """
    if not BOT_TOKEN:
        return False

    # Check data_check_string
    check_string = '\n'.join([
        f"{k}={v}" for k, v in sorted(auth_data.items())
        if k != 'hash'
    ])

    # Calculate secret key
    secret_key = hashlib.sha256(BOT_TOKEN.encode()).digest()

    # Calculate hash
    calculated_hash = hmac.new(
        secret_key,
        check_string.encode(),
        hashlib.sha256
    ).hexdigest()

    return calculated_hash == auth_data.get('hash', '')


def handler(request):
    """
    Handle Telegram login authentication.

    POST /api/web/auth
    Body: Telegram auth data from widget
    """
    if request.method != 'POST':
        return {
            'statusCode': 405,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': 'Method not allowed'})
        }

    try:
        # Parse request body
        body = request.body
        if isinstance(body, bytes):
            body = body.decode('utf-8')

        auth_data = json.loads(body)

        # Verify authentication
        is_valid = verify_telegram_auth(auth_data)

        if is_valid:
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'success': True,
                    'user': {
                        'id': auth_data.get('id'),
                        'first_name': auth_data.get('first_name'),
                        'last_name': auth_data.get('last_name'),
                        'username': auth_data.get('username'),
                        'photo_url': auth_data.get('photo_url')
                    }
                })
            }
        else:
            return {
                'statusCode': 401,
                'headers': {'Content-Type': 'application/json'},
                'body': json.dumps({
                    'success': False,
                    'error': 'Invalid authentication'
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
