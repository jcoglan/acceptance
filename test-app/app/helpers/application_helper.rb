module ApplicationHelper
  include Acceptance::FormHelper
  
  def field(f, name)
    <<-HTML
      <div class="field">
        #{ f.label(name) }
        #{ f.text_field(name) }
      </div>
    HTML
  end
end

