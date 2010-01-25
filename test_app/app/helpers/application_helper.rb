module ApplicationHelper
  
  include Acceptance::FormHelper
  Acceptance.yield_with :acceptance_scripts
  
  def field(form, field, type = :text_field)
    <<-HTML
    <div class="field">
      #{ form.label field }
      #{ form.send(type, field) }
    </div>
    HTML
  end
  
end

