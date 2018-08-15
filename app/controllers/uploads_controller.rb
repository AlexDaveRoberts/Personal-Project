class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update]
  before_action :authenticate_user!
  require 'net/http'
  require 'json'
  require 'fileutils'

  def index
    @upload = Upload.new
    @user_uploads = Upload.where(user_id: current_user.id)
    if @user_uploads.first.present?
      @latestImage = Upload.where(user_id: current_user.id).last.image_url

      uri = URI('https://uksouth.api.cognitive.microsoft.com/face/v1.0/detect')
      uri.query = URI.encode_www_form({
          'returnFaceId' => 'true',
          'returnFaceLandmarks' => 'false',
          'returnFaceAttributes' => 'age,gender,headPose,smile,facialHair,glasses,' +
              'emotion,hair,makeup,occlusion,accessories,blur,exposure,noise'
      })

      request = Net::HTTP::Post.new(uri.request_uri)

      request['Ocp-Apim-Subscription-Key'] = 'ecb202e4074246e795ca9f0d1c9577d6'
      request['Content-Type'] = 'application/json'

      request.body = "{\"url\": \"" + @latestImage + "\"}"

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
      end

      hash_response = JSON.parse(response.body)
      @gender = hash_response[0]["faceAttributes"]["gender"]
      @age = hash_response[0]["faceAttributes"]["age"]
      @smile = hash_response[0]["faceAttributes"]["smile"]
      @happiness = hash_response[0]["faceAttributes"]["emotion"]["happiness"]
      @anger = hash_response[0]["faceAttributes"]["emotion"]["anger"]
      @contempt = hash_response[0]["faceAttributes"]["emotion"]["contempt"]
      @disgust = hash_response[0]["faceAttributes"]["emotion"]["disgust"]
      @fear = hash_response[0]["faceAttributes"]["emotion"]["fear"]
      @neutral = hash_response[0]["faceAttributes"]["emotion"]["neutral"]
      @sadness = hash_response[0]["faceAttributes"]["emotion"]["sadness"]
      @surprise = hash_response[0]["faceAttributes"]["emotion"]["surprise"]
      @beard = hash_response[0]["faceAttributes"]["facialHair"]["beard"]
      @moustache = hash_response[0]["faceAttributes"]["facialHair"]["moustache"]
      @glasses = hash_response[0]["faceAttributes"]["glasses"]
      if hash_response[0]["faceAttributes"]["accessories"].present?
        @accessories = hash_response[0]["faceAttributes"]["accessories"].first["type"]
      end
      if hash_response[0]["faceAttributes"]["hair"]["hairColor"].present?
        @hair = hash_response[0]["faceAttributes"]["hair"]["hairColor"].first["color"]
      end
      @eyeMakeup = hash_response[0]["faceAttributes"]["makeup"]["eyeMakeup"]
      @lipMakeup = hash_response[0]["faceAttributes"]["makeup"]["lipMakeup"]
      @blur = hash_response[0]["faceAttributes"]["blur"]["blurLevel"]
      @blurValue = hash_response[0]["faceAttributes"]["blur"]["value"]
      @exposure = hash_response[0]["faceAttributes"]["exposure"]["exposureLevel"]
      @exposureValue = hash_response[0]["faceAttributes"]["exposure"]["value"]
      @noise = hash_response[0]["faceAttributes"]["noise"]["noiseLevel"]
    end
  end

  def create
    @upload = Upload.new(upload_params.merge(user_id: current_user.id))
    if @upload.save
      session[:upload_success] = true
      redirect_to uploads_path
    else
      render :index
    end
  end

  def destroy
    set_upload.remove_image!
    set_upload.destroy!
    session[:delete_success] = true
    redirect_to uploads_path
  end

  def snapshot
    data = params[:url]
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])

    FileUtils.mkdir_p "#{Rails.root}/public/uploads/upload/unprocessed"

    current_date = Time.now.strftime("snapshot%d%m%Y%H%M%S")
    File.open("#{Rails.root}/public/uploads/upload/unprocessed/#{current_date}.png", 'wb') do |f|
      f.write image_data
    end

    @upload1 = Upload.new(user_id: current_user.id)
    image_path = "#{Rails.root}/public/uploads/upload/unprocessed/#{current_date}.png"

    @upload1.image = File.open(image_path)
    if @upload1.save!
      FileUtils.rm_rf("#{Rails.root}/public/uploads/upload/unprocessed")
      session[:upload_success] = true
      session[:upload_first] = true
      redirect_to uploads_path
    else
      render :index
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:image, :remove_image)
  end

  def set_upload
    @upload = Upload.find(params[:id])
  end
end
