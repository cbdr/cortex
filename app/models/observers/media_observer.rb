class MediaObserver < ActiveRecord::Observer
  def before_save(media)
    extract_dimensions(media)
    generate_digest(media)
  end

  def before_destroy(media)
    prevent_consumed_deletion(media)
  end

  private

  def image?(media)
    media.attachment_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
  end

  def extract_dimensions(media)
    return unless image?(media)
    tempfile = media.attachment.queued_for_write[:original]
    unless tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      media.dimensions = [geometry.width.to_i, geometry.height.to_i]
    end
  end

  def generate_digest(media)
    tempfile = media.attachment.queued_for_write[:original]
    unless tempfile.nil?
      media.digest = Digest::SHA1.file(tempfile.path).to_s
    end
  end

  def prevent_consumed_deletion(media)
    if media.consumed?
      raise Cortex::Exceptions::ResourceConsumed
    end
  end
end
