import React, { useState } from 'react';
import styles from './styles.module.css';

/**
 * Claudia AI Widget - Your Personal Coding & Security Consultant
 *
 * Expert in:
 * - Smart Contracts (Solidity, Foundry)
 * - DevOps & Infrastructure
 * - Security Methodology & Forensics
 * - Cyber Incident Intelligence
 * - Best Practices & Code Review
 */
export default function ClaudiaWidget(): JSX.Element {
  const [isOpen, setIsOpen] = useState(false);
  const [query, setQuery] = useState('');

  const expertiseAreas = [
    {
      icon: '🔐',
      title: 'Smart Contracts',
      description: 'Solidity, Foundry, Web3 Security',
      examples: ['How do I prevent reentrancy?', 'Best Foundry test patterns?']
    },
    {
      icon: '⚙️',
      title: 'DevOps',
      description: 'CI/CD, Docker, Infrastructure',
      examples: ['GitHub Actions optimization?', 'Docker security best practices?']
    },
    {
      icon: '🛡️',
      title: 'Security',
      description: 'Forensics, Auditing, Methodology',
      examples: ['Latest CVE vulnerabilities?', 'How to audit smart contracts?']
    },
    {
      icon: '🔥',
      title: 'Cyber Intel',
      description: 'Recent incidents, threat analysis',
      examples: ['Recent DeFi exploits?', 'Current threat landscape?']
    }
  ];

  const quickQuestions = [
    'How do I prevent SSRF attacks?',
    'Best practices for rate limiting?',
    'What are recent smart contract vulnerabilities?',
    'How to set up Foundry tests?',
    'Explain zero-knowledge proofs',
    'Latest DeFi security incidents',
  ];

  const handleAskClaudia = () => {
    // Open Claude chat with pre-filled context
    const claudiaPrompt = encodeURIComponent(
      `Hi Claudia! I need help with: ${query}\n\nContext: I'm working on a project and need expert advice on coding, smart contracts, DevOps, security, or cyber incidents.`
    );

    // Replace with actual Claude chat URL when available
    window.open(`https://claude.ai/new?q=${claudiaPrompt}`, '_blank');
  };

  const handleQuickQuestion = (question: string) => {
    setQuery(question);
  };

  return (
    <div className={styles.claudiaWidget}>
      {/* Floating Action Button */}
      <button
        className={styles.claudiaFAB}
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Ask Claudia AI"
      >
        <div className={styles.claudiaAvatar}>
          <span className={styles.claudiaEmoji}>☕</span>
          <span className={styles.claudiaStatus}>●</span>
        </div>
        <span className={styles.claudiaName}>Ask Claudia</span>
      </button>

      {/* Widget Panel */}
      {isOpen && (
        <div className={styles.claudiaPanel}>
          {/* Header */}
          <div className={styles.claudiaHeader}>
            <div className={styles.claudiaHeaderTitle}>
              <div className={styles.claudiaAvatarLarge}>☕</div>
              <div>
                <h3>Claudia AI</h3>
                <p>Your Personal Coding & Security Consultant</p>
              </div>
            </div>
            <button
              className={styles.claudiaClose}
              onClick={() => setIsOpen(false)}
              aria-label="Close"
            >
              ✕
            </button>
          </div>

          {/* Expertise Cards */}
          <div className={styles.claudiaExpertise}>
            <h4>What I Can Help With:</h4>
            <div className={styles.expertiseGrid}>
              {expertiseAreas.map((area, idx) => (
                <div key={idx} className={styles.expertiseCard}>
                  <div className={styles.expertiseIcon}>{area.icon}</div>
                  <div className={styles.expertiseContent}>
                    <strong>{area.title}</strong>
                    <p>{area.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Quick Questions */}
          <div className={styles.claudiaQuickQuestions}>
            <h4>Popular Questions:</h4>
            <div className={styles.quickQuestionsGrid}>
              {quickQuestions.map((question, idx) => (
                <button
                  key={idx}
                  className={styles.quickQuestionBtn}
                  onClick={() => handleQuickQuestion(question)}
                >
                  {question}
                </button>
              ))}
            </div>
          </div>

          {/* Input Area */}
          <div className={styles.claudiaInput}>
            <textarea
              placeholder="Ask me about smart contracts, DevOps, security, forensics, or recent cyber incidents..."
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              rows={3}
              className={styles.claudiaTextarea}
            />
            <button
              className={styles.claudiaSubmit}
              onClick={handleAskClaudia}
              disabled={!query.trim()}
            >
              Ask Claudia ☕
            </button>
          </div>

          {/* Footer */}
          <div className={styles.claudiaFooter}>
            <p>
              <strong>Powered by:</strong> Claude 3.5 Sonnet |
              <strong> Expertise:</strong> Smart Contracts, DevOps, Security, Cyber Intel
            </p>
            <p className={styles.claudiaTagline}>
              <em>"Fast, precise, economical - caffeinated code consulting!"</em> ☕💼
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
