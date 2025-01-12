module ApplicationHelper
  FLASH_TYPE_HASH = { success: 'green', error: 'yellow', alert: 'red', notice: 'indigo' }.freeze

  def title(title)
    title
  end
  def alert_color(flash_type)
    (FLASH_TYPE_HASH[flash_type.to_sym] || flash_type.to_s)
  end

  def flash_messages(_opts = [])
    return '' unless flash.any?

    # remove any blank devise timeout errors
    flash.delete(:timedout)
    flash.each do |msg_type, message|
      # You don't need to create an empty alert message
      next if message.blank? || message.to_s.length.zero?

      concat(tag.div(class: "bg-#{alert_color(msg_type)}-50 p-5 lg:w-full rounded border-l-4 border-#{alert_color(msg_type)}-400 mb-5", role: 'alert') do
        concat(tag.p(message, class: "text-sm text-#{alert_color(msg_type)}-500"))
      end)
    end
    nil
  end

  # for outputting an objects error messages
  def errors_for(object)
    return '' unless object.errors.any?

    content_tag(:div, class: 'text-sm bg-red-50 rounded p-5 mb-5') do
      concat(content_tag(:div, class: 'text-red-600 font-medium') do
        concat "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.name.downcase} from being saved:"
      end)
      concat(content_tag(:ul, class: 'px-0 text-red-500 italic font-sm') do
        object.errors.full_messages.each do |msg|
          concat content_tag(:li, msg, class: 'list-disc px-0 py-1 mx-4')
        end
      end)
    end
  end
end
