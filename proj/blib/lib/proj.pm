package proj;
use Dancer ':syntax';
use Dancer::Plugin::Mongo;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

post '/upload' => sub {
    my $user = param 'user';
    my $img  = upload 'image';

    my $img_data = $img->content;
    my $obj = {
        user => $user,
        img  => $img_data,
    };
    mongo->database->collection->insert($obj);
};

get '/images/:user' => sub {
    my $user = param 'user';
    debug 'user = ' . $user;
    my $cursor = mongo->database->collection->find({ user => $user });
    my @objects = $cursor->all;

    my $result = {
        images => [@objects]
    };

    return to_json($result);
};

true;
