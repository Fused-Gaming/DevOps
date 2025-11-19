"""
Telegram webhook management API
"""
from http.server import BaseHTTPRequestHandler
import json
import urllib.request
import urllib.parse


class handler(BaseHTTPRequestHandler):
    def do_POST(self):
        """Set or update a Telegram webhook"""
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))

            bot_token = data.get('bot_token')
            webhook_url = data.get('webhook_url')

            if not bot_token or not webhook_url:
                self.send_response(400)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({
                    "error": "bot_token and webhook_url required"
                }).encode())
                return

            # Set webhook
            telegram_url = f'https://api.telegram.org/bot{bot_token}/setWebhook'
            payload = json.dumps({'url': webhook_url}).encode('utf-8')

            req = urllib.request.Request(
                telegram_url,
                data=payload,
                headers={'Content-Type': 'application/json'}
            )

            with urllib.request.urlopen(req) as response:
                result = json.loads(response.read().decode('utf-8'))

            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(result).encode())

        except Exception as e:
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({"error": str(e)}).encode())

    def do_GET(self):
        """Get webhook info"""
        try:
            # Parse query parameters
            query = urllib.parse.urlparse(self.path).query
            params = urllib.parse.parse_qs(query)

            bot_token = params.get('bot_token', [None])[0]

            if not bot_token:
                self.send_response(400)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({
                    "error": "bot_token query parameter required"
                }).encode())
                return

            # Get webhook info
            telegram_url = f'https://api.telegram.org/bot{bot_token}/getWebhookInfo'

            with urllib.request.urlopen(telegram_url) as response:
                result = json.loads(response.read().decode('utf-8'))

            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(result).encode())

        except Exception as e:
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({"error": str(e)}).encode())

    def do_OPTIONS(self):
        """Handle CORS preflight"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
