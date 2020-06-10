json.extract! email, :id, :name, :subject, :content, :created_at, :updated_at
json.url email_url(email, format: :json)
