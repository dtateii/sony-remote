class Api {

  static const ipv4 = '10.1.10.81';
  static const port = '10000';
  static String getUri(lib) {
    return 'http://' + ipv4 + ':' + port + '/sony/' + lib;
  }

}

class Routing {

  // Input and Output URIs
  static String getUri(common) {
    switch (common) {
      case 'projector':
        return 'extOutput:zone?zone=1';
      case 'tv':
        return 'extOutput:zone?zone=4';
      case 'meet':
        return 'extInput:bd-dvd';
      case 'confmac':
        return 'extInput:sat-catv';
      case 'appletv':
        return 'extInput:game';
      case 'chromecast':
        return 'extInput:video?port=2';
      case 'hdmi':
        return 'extInput:video?port=1';
      default:
        return '';
    }
  }

}