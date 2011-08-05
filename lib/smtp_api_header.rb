#!/usr/bin/ruby
# Version 1.0
# Last Updated 6/22/2009
require 'json'
 
class SmtpApiHeader
  # SendGrid’s SMTP API allows developers to deliver custom handling instructions for e-mail. 
  # This is accomplished through a header,X-SMTPAPI, that is inserted into the message. 
  # The header is a JSON encoded list of instructions and options for that email.
  
  def initialize()
    @data = {}
  end  
  
  # Provide either a single recipient or a list of recipients. Using this function, 
  # it is possible to send one e-mail from your system that will be delivered to many addresses.
  def addTo(to)
    @data['to'] ||= []
    @data['to'] += to.kind_of?(Array) ? to : [to]
  end
  
  # Specify substitution variables for multi recipient e-mails. This would allow you to, 
  # for example, substitute the string ‘<% name %>‘ with a recipient’s name.
  def addSubVal(var, val)
    if not @data['sub']
      @data['sub'] = {}
    end
    if val.instance_of?(Array)
      @data['sub'][var] = val  
    else
      @data['sub'][var] = [val]    
    end
  end
  
  # Specify unique arg values.
  def setUniqueArgs(val)
    if val.instance_of?(Hash)
      @data['unique_args'] = val
    end
  end
  
  # Sets a cetegory for an e-mail to be logged as. You may use any category name you like.
  def setCategory(cat)
    @data['category'] = cat
  end
  
  # Adds/changes a setting for a filter. Settings specified in the header will override configured settings.
  # Note: ‘filter’ is the app.
  def addFilterSetting(fltr, setting, val)
    if not @data['filters']
      @data['filters'] = {}
    end
    if not @data['filters'][fltr]
      @data['filters'][fltr] = {}
    end
    if not @data['filters'][fltr]['settings']
      @data['filters'][fltr]['settings'] = {}
    end
    @data['filters'][fltr]['settings'][setting] = val
  end
  
  # Returns JSON version of data.
  def asJSON()
    json = JSON.generate @data
    return json.gsub(/(["\]}])([,:])(["\[{])/, '\\1\\2 \\3')
  end
  
  # Returns the full header which can be inserted into an e-mail.
  def as_string()
    json  = asJSON()
    str = 'X-SMTPAPI: %s' % json.gsub(/(.{1,72})( +|$\n?)|(.{1,72})/,"\\1\\3\n")
    return str    
  end
 
end