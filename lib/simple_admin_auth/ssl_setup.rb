require 'openid/fetchers'

if OpenID.fetcher.ca_file.nil?
  # To override the location, set OpenID.fetcher.ca_file before this file is required
  # TODO: This is fairly OS-specific. Is there any gem that allows us to do this in a cross-platform manner?

  CA_CERT_LOCATIONS = [
      '/usr/lib/ssl/certs/ca-certificates.crt',     # Ubuntu/Debian
      '/etc/ssl/certs/ca-certificates.crt',         # Ubuntu/Debian
      '/opt/local/share/curl/curl-ca-bundle.crt',   # Mac - sudo port install curl-ca-bundle
  ]

  CA_CERT_LOCATIONS.each do |location|
    if File.exist? location
      OpenID.fetcher.ca_file = location
      break
    end
  end

  if OpenID.fetcher.ca_file.nil?
    # We don't want OpenID to default to not using any CA certs.
    OpenID.fetcher.ca_file = 'Please specify OpenID.fetcher.ca_file'
    raise StandardError, 'CA certificates not found. Please specify OpenID.fetcher.ca_file.'
  end
end
