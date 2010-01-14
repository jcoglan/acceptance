module ApplicationHelper
  
  include Acceptance::FormHelper
  
  def field(form, field, type = :text_field)
    <<-HTML
    <div class="field">
      #{ form.label field }
      #{ form.send(type, field) }
    </div>
    HTML
  end
  
end

