; ----------------
; Generated makefile from http://drushmake.me
; Permanent URL: http://drushmake.me/file.php?token=7ff8372fcdf8
; ----------------
;
; This is a working makefile - try it! Any line starting with a `;` is a comment.

; Core version
; ------------
; Each makefile should begin by declaring the core version of Drupal that all
; projects should be compatible with.

core = 7.x

; API version
; ------------
; Every makefile needs to declare its Drush Make API version. This version of
; drush make uses API version `2`.

api = 2

; Core project
; ------------
; In order for your makefile to generate a full Drupal site, you must include
; a core project. This is usually Drupal core, but you can also specify
; alternative core projects like Pressflow. Note that makefiles included with
; install profiles *should not* include a core project.

; Drupal 7.x. Requires the `core` property to be set to 7.x.
projects[drupal][version] = 7.31
projects[drupal][overwrite] = TRUE

; SiteBuilding Modules
; ---------------------------------------------------------------
; Site Building Tools
projects[views][subdir] = "contrib"
projects[ctools][subdir] = "contrib"
projects[entity][subdir] = "contrib"
projects[pathauto][subdir] = "contrib"
projects[token][subdir] = "contrib"
projects[features][subdir] = "contrib"
projects[link][subdir] = "contrib"
projects[strongarm][subdir] = "contrib"

; Administration Modules
; ---------------------------------------------------------------
projects[admin_menu][subdir] = "contrib"

; PNX Features
; ---------------------------------------------------------------
; This pulls a repository from github:
;   * It is not a git submodule (only the files are pulled not .git folder)
;   * The includes[] pulls in another drush make file that adds only the modules used by the added feature.
; ---------------------------------------------------------------
