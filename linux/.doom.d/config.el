;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Nicolas Deutschmann"
      user-mail-address "nicolas.deutschmann@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; Project management
(setq projectile-project-search-path '("~/Projects/"))


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-roam-directory "~/org/")


;; daily note capture
(map! :leader
      :desc "Capture daily note"
      "n r d c" #'org-roam-dailies-capture-today)

(map! :leader
      :desc "Focus on current subtree (Zoom Narrow)"
      "n z n" #'org-narrow-to-subtree)

(map! :leader
      :desc "Unfocus current subtree (Zoom Wide)"
      "n z w" #'widen)

;; Templates
(setq org-roam-capture-templates
      '(
   ("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags:\n- tags :: \n"
                         )
      :unnarrowed t)
   
   ("k" "knowledge" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :knowledge: \n- tags :: \n\n* Summary\n\n* Resources"
                         )
      :unnarrowed t)

   ("r" "report" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
"#+title: ${title}
#+filetags: :report: \n- tags ::

* INSERTTAG ${title}
:PROPERTIES:
:CATEGORY: Report
:END:

path: ")
      :unnarrowed t)



   )
   )

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry "* %<%I:%M %p>: %?"
         :if-new (file+head "%<%Y-%m-%d>.org"
"#+title: %<%Y-%m-%d>

* Schedule

|        Time | Activity | Notes |
|-------------+----------+-------|
|        8-10 |          |       |
|       10-12 |          |       |
|       13-15 |          |       |
|       15-17 |          |       |
| Later Focus |          |       |

"))))



(setq bibliography-path "~/org/biblio.bib")
(setq pdf-path  "~/Zotero/storage/")
(setq bibliography-notes "~/org/")


(use-package! org-ref
    ;; :init
    ; code to run before loading org-ref
    :config
    (setq
         org-ref-completion-library 'org-ref-ivy-cite
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-default-bibliography (list bibliography-path)
         org-ref-bibliography-notes "~/org/bibnotes.org"
         org-ref-note-title-format "* NOTES %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
         org-ref-notes-directory bibliography-notes
         org-ref-notes-function 'orb-edit-notes
    ))

;; bibtex-completion
(after! org-ref
  (setq
   bibtex-completion-notes-path bibliography-notes
   bibtex-completion-bibliography bibliography-path
   bibtex-completion-pdf-field "file"
   bibtex-completion-notes-template-multiple-files
   (concat
    "#+TITLE: ${title}\n"
    "#+ROAM_KEY: cite:${=key=}"
    "#+ROAM_TAGS: ${keywords}"
    "#+CREATED:%<%Y-%m-%d-%H-%M-%S>"
    "Time-stamp: <>\n"
    "- tags :: \n"
    "* NOTES \n"
    ":PROPERTIES:\n"
    ":Custom_ID: ${=key=}\n"
    ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
    ":AUTHOR: ${author-abbrev}\n"
    ":JOURNAL: ${journaltitle}\n"
    ":DATE: ${date}\n"
    ":YEAR: ${year}\n"
    ":DOI: ${doi}\n"
    ":URL: ${url}\n"
    ":END:\n\n"
    )
   )
)
(setq bibtex-completion-cite-prompt-for-optional-arguments nil)

(setq org-roam-bibtex-preformat-keywords '(("citekey" . "=key=")
                                           "author-abbrev"
                                           "author-or-editor", "url", "journaltitle"))

(use-package! org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref)) 

(map! :leader
      :desc "Open Bibliography manager"
      "o b" #'helm-bibtex)

;;Latex Preview
;;
(map! :leader
      :desc "Toggle Latex Preview"
      "t L" #'org-latex-preview)

;; Alias Management
(map! :leader
      :desc "Add alias"
      "n r a" #'org-roam-alias-add)

;; Note edition
(map! :leader
      (:prefix "n"
      (:desc "Edit" :prefix "e"
       :desc "Convert to heading" "h" #'org-toggle-heading
       :desc "Convert to checkbox" "t" #'org-todo
       :desc "Convert to item" "i" #'org-toggle-item
       :desc "Increase heading" "k" #'org-do-promote
       :desc "Decrease heading" "j" #'org-do-demote
       )))

;; Setup for TODOS
;;
(setq org-use-fast-todo-selection nil)
 (setq org-todo-keywords
  '((sequence "TODO"
      "DONE")))

;; Deactivate autocompletion in org
(setq org-roam-completion-everywhere nil)
(setq company-global-modes '(not org-mode))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Disable exit prompt
(setq confirm-kill-emacs nil)

;; Start in maximized mode
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Set font size
(set-face-attribute 'default nil :height 140)

;; Setup HTML publishing
(add-to-list 'org-publish-project-alist
 `("org-notes"
 :base-directory "~/org/"
 :base-extension "org"
 :publishing-directory "~/public_html/"
 :recursive t
 :publishing-function org-html-publish-to-html
 :headline-levels 4             ; Just the default for this project.
 :auto-preamble t
 ))


(setq org-attach-store-link-p 'attached)

(setq dnd-protocol-alist nil)
