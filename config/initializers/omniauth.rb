#For Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'xH31FWQf4QKbjluVhgHXA', 'f630Zqxq4gfqXSDr18BPfuFsSaFW1oginzVpkf73ws'
end