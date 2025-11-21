"""
Vercel deployments API endpoint
"""
from http.server import BaseHTTPRequestHandler
import json
import os
import subprocess


class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        """Get list of deployments"""
        try:
            # Run vercel ls command (requires vercel CLI in deployment)
            # For now, return static data
            deployments = {
                "projects": [
                    {
                        "name": "attorney-finder-bot",
                        "url": "https://attorney-finder-bot.vercel.app",
                        "status": "ready",
                        "created": "2025-11-18T16:41:00Z"
                    },
                    {
                        "name": "dev-ops",
                        "url": "https://dev-ops-omega.vercel.app",
                        "status": "ready",
                        "created": "2025-11-18T16:41:00Z"
                    }
                ]
            }

            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(deployments).encode())

        except Exception as e:
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"error": str(e)}).encode())

    def do_OPTIONS(self):
        """Handle CORS preflight"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
