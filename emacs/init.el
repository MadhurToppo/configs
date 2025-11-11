;;; init.el --- Spacemacs Initialization File -*- no-byte-compile: t; lexical-binding: nil; -*-
;;
;; Copyright (c) 2012-2025 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;; ---------------------------------------------------------------------------
;; * Startup Optimization
;; ---------------------------------------------------------------------------
;; Increase garbage collection threshold to speed up startup.
(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)

;; ---------------------------------------------------------------------------
;; * Load Core Paths
;; ---------------------------------------------------------------------------
;; Load the paths to Spacemacs core files.
(load (concat (file-name-directory load-file-name) "core/core-load-paths")
      nil (not init-file-debug))

;; ---------------------------------------------------------------------------
;; * Load Version Info
;; ---------------------------------------------------------------------------
;; Load Spacemacs and Emacs version information.
(load (concat spacemacs-core-directory "core-versions")
      nil (not init-file-debug))

;; ---------------------------------------------------------------------------
;; * Remove Stale Compiled Files
;; ---------------------------------------------------------------------------
;; Remove old compiled files if Emacs version has changed.
(load (concat spacemacs-core-directory "core-compilation")
      nil (not init-file-debug))
(load spacemacs--last-emacs-version-file t (not init-file-debug))

;; Update saved Emacs version if necessary.
(unless (string= spacemacs--last-emacs-version emacs-version)
  (spacemacs//update-last-emacs-version))

;; ---------------------------------------------------------------------------
;; * Emacs Version Check
;; ---------------------------------------------------------------------------
;; Stop initialization if Emacs is too old.
(when (not (version<= spacemacs-emacs-min-version emacs-version))
  (error (concat "Your version of Emacs (%s) is too old. "
                 "Spacemacs requires Emacs version %s or above.")
         emacs-version spacemacs-emacs-min-version))

;; -------------------------------------------------------------------------
;; * Startup Speed Tweaks
;; -------------------------------------------------------------------------
;; Simplify file-name-handler-alist for faster startup.
;; Prefer newer files over older compiled ones.
(let ((load-prefer-newer t)
      (file-name-handler-alist '(("\\.gz\\'" . jka-compr-handler))))

  ;; -----------------------------------------------------------------------
  ;; * Load Spacemacs Core
  ;; -----------------------------------------------------------------------
  ;; Load main Spacemacs core and configuration layers.
  (require 'core-spacemacs)
  (configuration-layer/load-lock-file)
  (spacemacs/init)
  (configuration-layer/stable-elpa-init)
  (configuration-layer/load)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)

  ;; -----------------------------------------------------------------------
  ;; * Start Emacs Server (Optional)
  ;; -----------------------------------------------------------------------
  ;; Start Emacs server if enabled in user config.
  (when (and dotspacemacs-enable-server (not noninteractive))
    (require 'server)
    (when dotspacemacs-server-socket-dir
      (setq server-socket-dir dotspacemacs-server-socket-dir))
    (unless (or (daemonp) (server-running-p))
      (message "Starting a server...")
      (server-start))))

;; Org-mode customization
;; (setq org-hide-leading-stars t)
(setq org-superstar-leading-bullet nil)
(setq org-startup-indented t)
(setq org-startup-folded t)
(spaceline-toggle-org-clock-on)

;; Define todo states
(setq org-todo-keywords
      '((sequence "TODO(t)" "SCHEDULED(s)" "NEXT(n)" "ACTIVE(a)" "PAUSED(p)" "|" "DECLINED(x)" "DONE(D)")))

;; Set todo keyword colors
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "orange" :weight bold)
              ("SCHEDULED" :foreground "light blue" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("ACTIVE" :foreground "magenta" :weight bold)
              ("PAUSED" :foreground "violet" :weight bold)
              ("DECLINED" :foreground "dark green" :weight bold)
              ("DONE" :foreground "dark green" :weight bold))))

;; Org-todo automatically change to done when all children are done
(defun org-summary-todo (n-done n-not-done)
  ;; "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-todo-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "ACTIVE"))))

(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)

;; Load org agenda files
(load-library "find-lisp")
(add-hook 'org-agenda-mode-hook (lambda ()
                                  (setq org-agenda-files
                                        (find-lisp-find-files "~/workspace/journal" "\.org$"))))

;; Set default launch terminal to iterm
(setq terminal-here-mac-terminal-command 'kitty)

;; Treemacs resize icons
(treemacs-resize-icons 12)

;; Spacemacs transparency
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)

;; Add org-mode priorities
(setq org-highest-priority ?A
      org-default-priority ?B
      org-lowest-priority ?D)

;; Set org-mode priority colors
(setq org-priority-faces '((?A . (:foreground "green"))
                           (?B . (:foreground "magenta"))
                           (?C . (:foreground "orange"))
                           (?D . (:foreground "yellow"))))

;; Set counsel default search engine to google
(setq counsel-search-engine 'google)

;; Disable ivy counsel fuzzy search
(setq ivy-initial-inputs-alist nil)

;; Change org pomodoro timer
(setq org-pomodoro-length 60)
(setq org-pomodoro-short-break-length 5)
(setq org-pomodoro-long-break-length 60)
(setq org-pomodoro-long-break-frequency 60)

;; Set vterm timer delay to improve performance
(setq vterm-timer-delay 0.005)

;; Increase to 1 MB from default 4 KB, which is too low for TUI apps like lazygit
(setq read-process-output-max (* 1024 1024)) ;; 1 MB

;; Load OrgModeClockingXBar
(load-file "/Users/madhurtoppo/.emacs.d/workspace/OrgModeClockingXBar/OrgModeClockingXBar.el")
