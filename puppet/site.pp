# Default Drupal 8 development site.

node default {

  # Basic includes.	
  include drupal

  # Advanced includes.
  drupal::site { 'd8':
    mysql_host => '%',
  }

}

