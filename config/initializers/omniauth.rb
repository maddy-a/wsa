#For Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'xH31FWQf4QKbjluVhgHXA', 'f630Zqxq4gfqXSDr18BPfuFsSaFW1oginzVpkf73ws'
  provider :facebook, '108621609282833', '425a62ae451c433c80bf429c3b7d03d2'
end