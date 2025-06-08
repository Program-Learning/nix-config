{
  pkgs,
  config,
  ...
}: let
  domain = "ca.r";
in {
  # NOTE: local ca server for pki
  # https://localhost
  services.step-ca = {
    enable = false;
    intermediatePasswordFile = "/dev/null";
    address = "0.0.0.0";
    port = 1443;
    settings = {
      root = "${config.age.secrets.rootCAcrt.path}";
      crt = "${config.age.secrets.intermediateCAcrt.path}";
      key = "${config.age.secrets.intermediateCAkey.path}";
      dnsNames = [domain];
      logger.format = "text";
      db = {
        type = "badger";
        dataSource = "/var/lib/step-ca/db";
      };
      authority = {
        provisioners = [
          {
            type = "ACME";
            name = "acme";
            forceCN = true;
          }
        ];
        claims = {
          maxTLSCertDuration = "2160h";
          defaultTLSCertDuration = "2160h";
        };
        backdate = "1m0s";
      };
      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };
    };
  };
}
