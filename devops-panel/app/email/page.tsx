"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Button from "@/components/ui/button";
import EmailStatus from "@/components/email/email-status";
import EmailTemplates from "@/components/email/email-templates";
import { Mail, Settings, ArrowLeft } from "lucide-react";

export default function EmailPage() {
  const router = useRouter();
  const [activeTab, setActiveTab] = useState("overview");

  return (
    <div className="min-h-screen p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-4 mb-4">
            <Button
              variant="ghost"
              icon={<ArrowLeft />}
              onClick={() => router.back()}
            >
              Back
            </Button>
          </div>
          <div>
            <h1 className="text-4xl font-bold text-gradient-sage mb-2 flex items-center gap-2">
              <Mail className="w-8 h-8" />
              Email Management System
            </h1>
            <p className="text-vln-gray">
              Manage email templates, track delivery, and configure settings
            </p>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-2 mb-8 border-b border-vln-border">
          <button
            onClick={() => setActiveTab("overview")}
            className={`px-4 py-2 font-medium transition-colors ${
              activeTab === "overview"
                ? "text-vln-sage border-b-2 border-vln-sage"
                : "text-vln-gray hover:text-white"
            }`}
          >
            Overview
          </button>
          <button
            onClick={() => setActiveTab("templates")}
            className={`px-4 py-2 font-medium transition-colors ${
              activeTab === "templates"
                ? "text-vln-sage border-b-2 border-vln-sage"
                : "text-vln-gray hover:text-white"
            }`}
          >
            Templates
          </button>
          <button
            onClick={() => setActiveTab("settings")}
            className={`px-4 py-2 font-medium transition-colors flex items-center gap-2 ${
              activeTab === "settings"
                ? "text-vln-sage border-b-2 border-vln-sage"
                : "text-vln-gray hover:text-white"
            }`}
          >
            <Settings className="w-4 h-4" />
            Settings
          </button>
        </div>

        {/* Content */}
        {activeTab === "overview" && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <EmailStatus />
            <div className="grid grid-cols-1 gap-6">
              <div className="p-6 border border-vln-border rounded-lg bg-vln-card">
                <h3 className="text-lg font-semibold text-white mb-4">
                  Quick Stats
                </h3>
                <div className="space-y-3">
                  <div className="flex justify-between items-center">
                    <span className="text-vln-gray">Total Emails Sent</span>
                    <span className="text-2xl font-bold text-vln-sage">1,247</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-vln-gray">This Month</span>
                    <span className="text-2xl font-bold text-vln-blue">324</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-vln-gray">Open Rate</span>
                    <span className="text-2xl font-bold text-vln-purple">48%</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {activeTab === "templates" && (
          <div className="grid grid-cols-1 gap-6">
            <EmailTemplates />
          </div>
        )}

        {activeTab === "settings" && (
          <div className="max-w-2xl">
            <div className="p-6 border border-vln-border rounded-lg bg-vln-card">
              <h3 className="text-lg font-semibold text-white mb-6">
                Email Service Configuration
              </h3>

              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-vln-gray mb-2">
                    Email Service Provider
                  </label>
                  <select className="w-full px-4 py-2 bg-vln-border border border-vln-border rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-vln-sage">
                    <option value="sendgrid">SendGrid</option>
                    <option value="mailgun">Mailgun</option>
                    <option value="resend">Resend</option>
                    <option value="smtp">SMTP Server</option>
                  </select>
                  <p className="text-xs text-vln-gray mt-2">
                    Select your email service provider
                  </p>
                </div>

                <div>
                  <label className="block text-sm font-medium text-vln-gray mb-2">
                    API Token / Key
                  </label>
                  <input
                    type="password"
                    placeholder="Enter your API token"
                    className="w-full px-4 py-2 bg-vln-border border border-vln-border rounded-lg text-white placeholder-vln-gray focus:outline-none focus:ring-2 focus:ring-vln-sage"
                  />
                  <p className="text-xs text-vln-gray mt-2">
                    Your API token is securely stored in environment variables
                  </p>
                </div>

                <div>
                  <label className="block text-sm font-medium text-vln-gray mb-2">
                    From Email Address
                  </label>
                  <input
                    type="email"
                    placeholder="noreply@example.com"
                    className="w-full px-4 py-2 bg-vln-border border border-vln-border rounded-lg text-white placeholder-vln-gray focus:outline-none focus:ring-2 focus:ring-vln-sage"
                  />
                  <p className="text-xs text-vln-gray mt-2">
                    Default sender email address for outgoing emails
                  </p>
                </div>

                <div>
                  <label className="block text-sm font-medium text-vln-gray mb-2">
                    From Name
                  </label>
                  <input
                    type="text"
                    placeholder="DevOps Team"
                    className="w-full px-4 py-2 bg-vln-border border border-vln-border rounded-lg text-white placeholder-vln-gray focus:outline-none focus:ring-2 focus:ring-vln-sage"
                  />
                </div>

                <div className="flex gap-3 pt-4">
                  <Button variant="primary">Save Configuration</Button>
                  <Button variant="secondary">Test Connection</Button>
                </div>
              </div>
            </div>

            <div className="p-6 border border-vln-border rounded-lg bg-vln-card">
              <h3 className="text-lg font-semibold text-white mb-4">
                Webhook Configuration
              </h3>
              <p className="text-vln-gray text-sm mb-4">
                Configure webhooks to receive real-time email delivery events
              </p>

              <div>
                <label className="block text-sm font-medium text-vln-gray mb-2">
                  Webhook URL
                </label>
                <input
                  type="text"
                  value={`${typeof window !== "undefined" ? window.location.origin : ""}/api/email/webhook`}
                  readOnly
                  className="w-full px-4 py-2 bg-vln-border border border-vln-border rounded-lg text-white cursor-not-allowed opacity-75"
                />
                <p className="text-xs text-vln-gray mt-2">
                  Copy this URL to your email service provider webhook settings
                </p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
