ActiveAdmin.register_page "Store Settings" do
  menu priority: 6, label: "Store Settings"

  content title: "Store Settings" do
    columns do
      column do
        panel "Store Customization" do
          div class: "carousel-images-section" do
            h3 "Carousel Images"
            div class: "current-images" do
              if current_user.company.carousel_images.attached?
                ul do
                  current_user.company.carousel_images.each do |image|
                    li do
                      div class: "image-container" do
                        div class: "image-wrapper" do
                          image_tag(rails_blob_url(image), class: "preview-image")
                        end
                        div class: "button-wrapper" do
                          button_to "Remove", admin_panel_store_settings_delete_carousel_image_path(current_user.company, image_id: image.id),
                            method: :delete,
                            class: "delete-button",
                            data: { confirm: "Are you sure you want to remove this image?" }
                        end
                      end
                    end
                  end
                end
              else
                para "No carousel images uploaded yet."
              end
            end

            div class: "upload-section" do
              active_admin_form_for current_user.company, url: admin_panel_store_settings_update_carousel_images_path(current_user.company), html: { multipart: true, method: :post } do |f|
                f.inputs do
                  f.input :carousel_images, as: :file, input_html: { multiple: true, accept: "image/*" }, label: "Add Images"
                end
                f.actions do
                  f.action :submit, label: "Upload Images"
                end
              end
            end
          end

          hr

          para "Other store customization options:"
          ul do
            li "Store theme customization"
            li "Logo upload"
            li "Custom domain settings"
            li "Email templates"
          end
        end
      end

      column do
        panel "Store Information" do
          attributes_table_for current_user.company do
            row :name
            row :subdomain
            row :created_at
            row :updated_at
          end
        end

        panel "About Page" do
          active_admin_form_for current_user.company, url: admin_panel_store_settings_update_about_page_path(current_user.company), html: { method: :patch } do |f|
            f.inputs do
              f.input :about_page_content, as: :text, input_html: { rows: 10 }
            end
            f.actions do
              f.action :submit, label: "Update About Page"
            end
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

  page_action :update_carousel_images, method: :post do
    company = current_user.company
    if params[:company] && params[:company][:carousel_images].present?
      begin
        company.carousel_images.attach(params[:company][:carousel_images])
        if company.valid?
          flash[:notice] = "Carousel images uploaded successfully"
        else
          flash[:error] = company.errors.full_messages.join(", ")
        end
      rescue StandardError => e
        flash[:error] = "Error uploading images: #{e.message}"
      end
    end
    redirect_to admin_panel_store_settings_path
  end

  page_action :delete_carousel_image, method: :delete do
    if params[:image_id].present?
      image = current_user.company.carousel_images.find(params[:image_id])
      image.purge
      flash[:notice] = "Image removed successfully"
    end
    redirect_to admin_panel_store_settings_path
  end

  page_action :update_about_page, method: :patch do
    company = current_user.company
    if company.update(about_page_content: params[:company][:about_page_content])
      flash[:notice] = "About page content updated successfully"
    else
      flash[:error] = company.errors.full_messages.join(", ")
    end
    redirect_to admin_panel_store_settings_path
  end
end
