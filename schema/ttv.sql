

/* Main tables */

CREATE TABLE users (
  user_id    INTEGER NOT NULL AUTO_INCREMENT,
  login      VARCHAR(64) NOT NULL,
  password   VARCHAR(60) NOT NULL,

  PRIMARY KEY (user_id),
  UNIQUE login_un (login)
) ENGINE=InnoDB COMMENT "The users table, to keep track of user credentials";


CREATE TABLE shows (
  show_id    INTEGER NOT  NULL AUTO_INCREMENT,
  short_name VARCHAR(64)  NOT NULL COMMENT "Short unique name for the show",
  name       VARCHAR(100) NOT NULL COMMENT "Full official name for the show",

  PRIMARY KEY (show_id),
  UNIQUE slug_un (short_name)
) ENGINE=InnoDB COMMENT "TV shows tracked by this instance";


/* Subscription management */

CREATE TABLE subscribers (
  user_id    INTEGER NOT NULL,
  show_id    INTEGER NOT NULL,
  rating     TINYINT COMMENT "User rating for the show, between 1 and 100",

  PRIMARY KEY (user_id, show_id, rating),
  INDEX show_id_idx (show_id, rating),

  CONSTRAINT subs_user_id_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
  CONSTRAINT subs_show_id_fk FOREIGN KEY (show_id) REFERENCES shows (show_id)
) ENGINE=InnoDB COMMENT "Tracks user/show subscriptions";


/* Season / Episode lists */

CREATE TABLE sets (
  set_id     INTEGER      NOT NULL AUTO_INCREMENT,
  type       CHAR(1)      NOT NULL DEFAULT "R" COMMENT "Set type: R regular season, P pilots, S specials",
  show_id    INTEGER      NOT NULL,
  name       VARCHAR(20)  NOT NULL COMMENT "Extra name of this set, like 1 or 2 for type R gives Season 1 or 2",

  PRIMARY KEY (set_id),
  UNIQUE type_named_un (type, name),

  CONSTRAINT sets_show_id_fk FOREIGN KEY (show_id) REFERENCES shows (show_id)
) ENGINE=InnoDB COMMENT "Episode sets for a show: season, pilots, specials, webisodes";


CREATE TABLE episodes (
  episode_id INTEGER      NOT NULL AUTO_INCREMENT,
  show_id    INTEGER      NOT NULL,
  set_id     INTEGER      NOT NULL,
  name       VARCHAR(10)  NOT NULL COMMENT "Name of the episode, most of the time is a number",
  rank       INTEGER      NOT NULL COMMENT "Rank of this episode, for sorting; most of the time the same as name",
  air_date   DATE         COMMENT "Date of first time it was aired",

  PRIMARY KEY (episode_id),
  UNIQUE epis_show_set_name (set_id, show_id, name),

  CONSTRAINT epis_show_id_fk FOREIGN KEY (show_id) REFERENCES shows (show_id),
  CONSTRAINT epis_set_id_fk  FOREIGN KEY (set_id)  REFERENCES sets (set_id)
) ENGINE=InnoDB COMMENT "Episode lists, per show, per set, with air date";


/* Seen / Unseen */

CREATE TABLE seen (
  user_id    INTEGER      NOT NULL,
  episode_id INTEGER      NOT NULL,
  show_id    INTEGER      NOT NULL,
  seen_at    DATETIME     NOT NULL,

  PRIMARY KEY (user_id, episode_id),
  INDEX (seen_at),

  CONSTRAINT seen_show_id_fk FOREIGN KEY (show_id) REFERENCES shows (show_id),
  CONSTRAINT seen_user_id_fk FOREIGN KEY (user_id)  REFERENCES users (user_id),
  CONSTRAINT seen_epi_id_fk  FOREIGN KEY (episode_id)  REFERENCES episodes (episode_id)
) ENGINE=InnoDB COMMENT "Keeps track of which episodes each user has seen and when";


/* Metadata */

CREATE TABLE metadata (
  meta_id    INTEGER NOT NULL AUTO_INCREMENT,
  obj_id     INTEGER NOT NULL,
  obj_type   TINYINT NOT NULL COMMENT "Type of object ID: 0 => shows, 1 => sets, 2 => episodes",

  source     VARCHAR(64) NOT NULL COMMENT "Source for this metadata blob (ex. RageTV, IMDB, etc)",
  meta       TEXT        NOT NULL COMMENT "JSON blob with metadata",

  PRIMARY KEY (meta_id),
  UNIQUE meta_obj_source_un (obj_id, obj_type, source)
) ENGINE=InnoDB COMMENT "JSON-based metadata";
