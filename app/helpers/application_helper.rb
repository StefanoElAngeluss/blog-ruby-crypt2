module ApplicationHelper
  # boolean green or red
  def boolean_label(value)
    case value
      when true
        # content_tag(:span, "Yes", class: "badge badge-success")
        content_tag(:span, value=("Oui"), class: "badge badge-success")
      when false
        content_tag(:span, value=("Non"), class: "badge badge-danger")
    end
  end
end
