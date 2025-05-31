package AnonChat;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::SQLite;

my @clients;

# This method will run once at server start
sub startup ($self) {
  # load SQLite and setup new DB
  my $sql = Mojo::SQLite->new('sqlite:chat.db');
  $self->helper(sql => sub {$sql});

  # Migrate DB schema (run only once)
  $sql->migrations->name('chat')->from_string(<<EOF)->migrate;
-- 1 up
CREATE TABLE messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nickname TEXT,
  message TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- 1 down
DROP TABLE messages;
EOF

  my $r = $self->routes;

  # Serve static frontend
  $r->get('/')->to(cb => sub ($c) {
    $c->render(template => 'index')
  });

  # Websocket route
  $r->websocket('/chat' => sub($c) {
    my $tx = $c->tx;
    push @clients, $tx;

    my $result = $self->sql->db->query(
      'SELECT nickname, message from messages ORDER BY id DESC LIMIT 50'
    );
    my @rows = reverse @{$result->hashes};

    $tx->send("🕘 Chat History:");
    $tx->send("• $_->{nickname}: $_->{message}") for @rows;

    
    $c->on(message => sub ($c, $msg) {
      # split nickname from messages
      my ($nickname, $text) = $msg =~ /^(.*?):\s+(.*)$/;

      # store chat messages in table
      $self->sql->db->query(
        'INSERT INTO messages (nickname, message) VALUES (?, ?)',
        $nickname, $text
      );

      # Broadcast to all clients
      for my $client (@clients) {
        $client->send($msg);
      }
    });

    $c->on(finish => sub ($c, $code, $reason) {
      @clients = grep {$_ != $c} @clients;
    });
  });
}

1;
