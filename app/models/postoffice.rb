class Postoffice < ActionMailer::Base

  def send_test(name, email)
    recipients  email 
    from        "admin@mogo.com.cn" 
    #headers     "Reply-to" => "#{email}"
    subject     "welcom to mogo x3"
    sent_on      Time.now
    content_type "text/html"
    # reply_to   "admin@mogo.com.tv"
 
    #@recipients   = email
    #@from         = params[:contact][:email]
    #headers         "Reply-to" => "#{email}"
    #@subject      = "Welcome to mogo 1"
    #@sent_on      = Time.now
    #@content_type = "text/html"

    body[:name]  = name
    body[:email] = email       
  end

  def send_video_recommendation(to_email, recommend)

		program = Program.find(recommend.program_id)

    recipients	 to_email
    from         recommend.user_email 
    subject      recommend.user_name + "推荐给您精彩的MOGO视频节目"
    sent_on      Time.now
    content_type "text/html"
 
	  body[:name]  = recommend.user_name
	  body[:comment] = recommend.comment
	  body[:program_id] = program.program_id
	  body[:program_name] = program.program_name_cn
  end

end
