module FormBuilder

  def form_errors
    return if (errors = self.object.errors).none?

    @template.content_tag :div, class: "alert alert-danger" do
      @template.content_tag(:ul) do
        errors.full_messages.map do |msg|
          @template.content_tag(:li, msg)
        end.join.html_safe
      end
    end
  end

end

ActionView::Helpers::FormBuilder.send :include, FormBuilder