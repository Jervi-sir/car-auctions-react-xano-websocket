realtime_channel auctionSession {
  public_messaging = {active: false}
  private_messaging = {active: false}
  settings = {
    anonymous_clients: true
    nested_channels  : true
    message_history  : 0
    auth_channel     : false
    presence         : false
  }
}