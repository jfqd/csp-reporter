class CreateCspReports < ActiveRecord::Migration[5.2]
  def change
    create_table :csp_reports do |t|
      t.string  :domain
      t.string  :blocked_uri
      t.string  :disposition
      t.string  :document_uri
      t.string  :effective_directive
      t.string  :violated_directive
      t.string  :referrer
      t.integer :status_code, null: false, default: 0
      t.json    :raw_report
      t.string  :raw_browser
      t.timestamps
    end
  end
end
