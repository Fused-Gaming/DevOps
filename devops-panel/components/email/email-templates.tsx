"use client";

import { useEffect, useState } from "react";
import Card from "@/components/ui/card";
import Button from "@/components/ui/button";
import { FileText, Plus, Trash2, Edit } from "lucide-react";

interface EmailTemplate {
  id: string;
  name: string;
  subject: string;
  description: string;
  createdAt: string;
}

export default function EmailTemplates() {
  const [templates, setTemplates] = useState<EmailTemplate[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchTemplates();
  }, []);

  const fetchTemplates = async () => {
    try {
      const response = await fetch("/api/email/templates");
      const data = await response.json();
      setTemplates(data.templates || []);
    } catch (error) {
      console.error("Failed to fetch templates:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteTemplate = async (id: string) => {
    if (!confirm("Are you sure you want to delete this template?")) return;

    try {
      const response = await fetch(`/api/email/templates`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id }),
      });

      if (response.ok) {
        setTemplates(templates.filter((t) => t.id !== id));
      }
    } catch (error) {
      console.error("Failed to delete template:", error);
    }
  };

  if (loading) {
    return <div className="text-vln-gray">Loading templates...</div>;
  }

  return (
    <Card className="glow-lift-purple">
      <Card.Header>
        <div className="flex items-center justify-between">
          <Card.Title className="flex items-center gap-2">
            <FileText className="w-5 h-5 text-vln-purple" />
            Email Templates
          </Card.Title>
          <Button variant="primary" size="sm" icon={<Plus />}>
            New Template
          </Button>
        </div>
      </Card.Header>

      <Card.Content>
        {templates.length === 0 ? (
          <div className="text-center py-8">
            <FileText className="w-12 h-12 text-vln-border mx-auto mb-3 opacity-50" />
            <p className="text-vln-gray mb-4">No email templates yet</p>
            <Button variant="primary" size="sm" icon={<Plus />}>
              Create Your First Template
            </Button>
          </div>
        ) : (
          <div className="space-y-2">
            {templates.map((template) => (
              <div
                key={template.id}
                className="p-3 border border-vln-border rounded-lg hover:bg-vln-border/50 transition-colors"
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h4 className="font-medium text-white">{template.name}</h4>
                    <p className="text-sm text-vln-gray mt-1">
                      Subject: {template.subject}
                    </p>
                    <p className="text-xs text-vln-gray/70 mt-1">
                      {new Date(template.createdAt).toLocaleDateString()}
                    </p>
                  </div>
                  <div className="flex gap-2 ml-4">
                    <Button
                      variant="ghost"
                      size="sm"
                      icon={<Edit className="w-4 h-4" />}
                      className="text-vln-blue hover:text-vln-blue/80"
                    />
                    <Button
                      variant="ghost"
                      size="sm"
                      icon={<Trash2 className="w-4 h-4" />}
                      className="text-red-500 hover:text-red-400"
                      onClick={() => handleDeleteTemplate(template.id)}
                    />
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </Card.Content>
    </Card>
  );
}
