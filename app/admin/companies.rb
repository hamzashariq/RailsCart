ActiveAdmin.register_page "Store Settings" do
  menu priority: 6, label: "Store Settings"

  content title: "Store Settings" do
    columns do
      column do
        panel "Store Information" do
          attributes_table_for current_user.company do
            row :name
            row :subdomain
            row :created_at
            row :updated_at
          end
        end
      end

      column do
        panel "Store Customization" do
          para "Store customization options will be available soon."
          para "Features coming in the next update:"
          ul do
            li "Store theme customization"
            li "Logo upload"
            li "Custom domain settings"
            li "Email templates"
          end
        end
      end
    end
  end

  sidebar :help do
    para "Need help customizing your store?"
    para "Contact support at:"
    para "support@example.com"
  end
end
