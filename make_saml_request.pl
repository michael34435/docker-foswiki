#!/usr/bin/perl
use LWP;
use LWP::UserAgent;
use Net::SAML2;
use Data::Dumper;

my $metadata 		= 'http://foswiki.local/metadata.xml';	# Local Copy of Metadata from Identity Provider
my $cacert 		= 'cacert.pem';				# The CA Cert for the Identity Providers Certificate
my $sp_signing_key	= 'sign.key';				# Service Provider Signing Key
my $sp_signing_cert	= 'sign.pem';				# Service Provider Signing Certificate
my $issuer		= 'https://foswiki.local';		# 	
my $provider_name	= 'Foswiki';				# Bug in Net::SAML2 prevents this from being sent

my $idp = Net::SAML2::IdP->new_from_url(url => $metadata, cacert => $cacert);
#print Dumper($idp);        

# my $sso_url = $idp->sso_url('urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect');

my $authnreq = Net::SAML2::Protocol::AuthnRequest->new(
      issuer        => $issuer,
      destination   => $idp->sso_url('urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'), # The ssl_url destination for redirect
      provider_name => $provider_name,
      nameid_format => $idp->formats->{'emailAddress'},
)->as_xml;
#print Dumper($authnreq);        

my $redirect = Net::SAML2::Binding::Redirect->new(
      key => $sp_signing_key,
      cert => $sp_signing_cert,
      param => 'SAMLRequest',
      url => $idp->sso_url('urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'), # The ssl_url destination for redirect
);
#print Dumper($redirect);        

my $url = $redirect->sign($authnreq);
print Dumper($url);        

# This is not for the request
# my $ret = $redirect->verify($url);

