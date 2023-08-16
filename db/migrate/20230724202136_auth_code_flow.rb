class AuthCodeFlow < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_code_flows do |t|
      t.text :issuer
      t.text :client_id
      t.text :code
      t.text :requested_scope
      t.text :granted_scope
      t.text :access_token
      t.text :id_token
      t.text :refresh_token
      t.text :auth_code_req_url
      t.text :token_req_url
      t.integer :expires_in

      t.timestamps
    end
  end
end
