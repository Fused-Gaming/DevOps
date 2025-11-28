import React, { useEffect } from 'react';
import ExecutionEnvironment from '@docusaurus/ExecutionEnvironment';

/**
 * Zammad Live Chat Widget - VLN Help & Support
 *
 * Provides real-time customer support via Zammad chat system
 * Available at: https://help.vln.gg
 */

declare global {
  interface Window {
    ZammadChat: any;
  }
}

export default function ZammadChat(): JSX.Element | null {
  useEffect(() => {
    // Only run on client side
    if (!ExecutionEnvironment.canUseDOM) {
      return;
    }

    // Load Zammad chat script
    const script = document.createElement('script');
    script.src = 'https://help.vln.gg/assets/chat/chat-no-jquery.min.js';
    script.async = true;

    script.onload = () => {
      // Initialize Zammad Chat after script loads
      if (window.ZammadChat) {
        new window.ZammadChat({
          background: 'rgb(9,13,14)',
          fontSize: '12px',
          chatId: 1
        });
      }
    };

    document.body.appendChild(script);

    // Cleanup on unmount
    return () => {
      if (document.body.contains(script)) {
        document.body.removeChild(script);
      }
    };
  }, []);

  // Component doesn't render anything - chat widget is injected by Zammad
  return null;
}
