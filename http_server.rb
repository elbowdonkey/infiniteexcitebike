# http_server.rb
# Originally provided by Nils Franzén:
# http://www.franzens.org/2011/10/writing-minimalistic-web-server-using.html

KEEPALIVE = "Connection: Keep-Alive\r\n".freeze
class ContentHandler < EM::Connection
  def post_init
    @parser = RequestParser.new
  end

  def receive_data(data)
    handle_http_request if @parser.parse(data)
  end

  def handle_http_request
    begin
      path       = @parser.env["REQUEST_PATH"]
      path       = "/index.html" if @parser.env["REQUEST_PATH"] == "/"
      keep_alive = @parser.persistent?
      data       = File.open("." + path, "r").read

      file_ext = path.split(".").last

      case file_ext
      when "js"
        content_type = "application/javascript"
      when "png"
        content_type = "image/png"
      when "html"
        content_type = "text/html"
      end

      send_data("HTTP/1.1 200 OK\r\nContent-Type: #{content_type}\r\nContent-Length: #{data.bytesize}\r\n#{ keep_alive  ? KEEPALIVE.clone : nil}\r\n#{data}")

      if keep_alive
        post_init
      else
        close_connection_after_writing
      end
    end
  rescue
  end
end
