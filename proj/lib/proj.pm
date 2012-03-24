package proj;
use Dancer ':syntax';
use Dancer::Plugin::Mongo;
use URI;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/upload' => sub {
    template 'upload';
};

post '/upload' => sub {
    my $user = param 'username';
    my $desc = param 'desc';
    my $img  = upload 'imagefile';

    my $u = URI->new("data:");

    $u->media_type ( $img->type    );
    $u->data       ( $img->content );

    insert_image($user, $desc, $u);
};

post '/images/upload' => sub {
    my $user = param 'username';
    my $desc = param 'desc';
    my $img  = param 'image_data';

    insert_image($user, $desc, $img);
};

get '/images/gallery/:user.json' => sub {
    my $user = param 'user';
    debug 'user = ' . $user;

    my @images = get_images_for_user($user);

    to_json { images => [@images] };
};

get '/images/gallery/:user' => sub {
    my $user = param 'user';
    my @images = get_images_for_user($user);

    template 'images', { images => [@images], user => $user };
};


sub get_images_for_user {
    my $user = shift;

    my $cursor = mongo->rdb->images->find({ user => $user });
    my @objects = $cursor->all;
    return @objects;
}

sub insert_image {
    my ($user, $desc, $img_data) = @_;

    my $obj = {
        user => $user,
        img  => $img_data,
        desc => $desc,
    };

    mongo->rdb->images->insert($obj);
}

true;
