class SendmailController < ApplicationController
	def send_test
 			Postoffice.deliver_send_test("francis", "wangfr108@gmail.com")
	end

  def send_video_recommendations
		recommends = ProgramRecommend.find(:all, :conditions => "sent_yn is null || sent_yn = ''")
  	
 		for recommend in recommends
 		
 			to_emails = recommend.to_email.split(",")
			
			for to_email in to_emails

				if to_email.size > 0
		 			Postoffice.deliver_send_video_recommendation(to_email, recommend)
				end
			end

			recommend.update_attributes({:sent_yn=>'y'})
	 	end
 end
  
end
