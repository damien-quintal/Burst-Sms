require 'happymapper'

module BurstSms
  module MessagesMultiple
    # include HappyMapper
    
    def send_message(from, recipients, message, options={})
      @response = post_to_api(send_message_body(from, recipients, message, options))
      Response.parse(@response.body)
    end
    
    def send_message_body(from, recipients, message, options={})
      build_request("messages.multiple",  :caller_id => check_valid_sender(from), 
                                          :mobile => sanitize_numbers(recipients), 
                                          :message => encode_msg(message),
                                          :sendtime => (options.has_key?(:sendtime) ? options[:sendtime] : nil),
                                          :contact_list => (options.has_key?(:contact_list) ? options[:contact_list] : nil))
    end

    class Response
      include HappyMapper
      tag 'xml'
  
      element :result, String, :xpath => "data/result"
      element :total_recipients, String, :xpath => "data/total_recipients"
      element :total_recipients_queued, String, :xpath => "data/total_recipients_queued"
      element :message_id, String, :xpath => "data/message_id"
      element :error, String
    
    end
  end
end