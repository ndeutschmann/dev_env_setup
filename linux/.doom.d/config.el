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
       (:prefix ("n z" . "focus")
        :desc "widen" "w" #'widen
        :desc "narrow to subtree" "n" #'org-narrow-to-subtree))


;; Templates
(setq org-roam-capture-templates
      '(
   ("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags:\n"
                         )
      :unnarrowed t)
   
   ("k" "knowledge" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :knowledge: \n\n* Summary\n\n* Resources"
                         )
      :unnarrowed t)

   ("r" "report" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
"#+title: ${title}
#+filetags: :report:

* INSERTTAG ${title}
:PROPERTIES:
:CATEGORY: Report
:END:

path: ")
      :unnarrowed t)

   ("b" "bibliography reference" plain
"#+filetags: :ref:

* Metadata
- Title: ${title}
- Authors: %^{author}
- Year: %^{year}

* Notes

"
         :target
         (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
         :unnarrowed t)
   ))

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry "* %<%I:%M %p>: %?"
         :if-new (file+head "%<%Y-%m-%d>.org"
"#+title: %<%Y-%m-%d>

* Tasks

** TODO

* Schedule

|        Time | Activity | Notes |
|-------------+----------+-------|
|        8-10 |          |       |
|       10-12 |          |       |
|       13-15 |          |       |
|       15-17 |          |       |
| Later Focus |          |       |

"))))


;; Heading templates (skeleton based)
;; Note edition
(define-skeleton org-labbook-skeleton "Insert a lab book heading"
  "Title: "
  "** "  (format-time-string "<%Y-%m-%d %a>") " " str "\n"
  ":PROPERTIES:\n"
  ":CATEGORY: Lab book\n"
  ":END:\n")
(define-skeleton org-meeting-skeleton "Insert a meeting heading"
  "Title: "
  "* "  (progn (org-time-stamp ".") nil) " " str "\n"
  ":PROPERTIES:\n"
  ":CATEGORY: Meeting\n"
  ":END:\n"
  "** Agenda\n"
  "** Notes")

(define-skeleton org-image-size "Specify image size"
  "#+attr_html: :width 500px"
  "#+attr_latex: :width 500px"
  )

(define-skeleton org-ref-insert-bib-section "Insert an Org-Ref bibliography section"
  ""
  "* Bibliography\n"
  (org-ref-insert-bibliography-link)
  "\n"
 )


(map! :leader
      (:prefix ("n i" . "insert")
       :desc "Lab book entry" "l" #'org-labbook-skeleton
       :desc "Meeting entry" "m" #'org-meeting-skeleton
       :desc "Image size spec" "i" #'org-image-size
       :desc "Bibliography section" "b" #'org-ref-insert-bib-section)
      )



(setq bibliography-path "~/org/biblio.bib")
(setq pdf-path  "~/Zotero/storage/")
(setq bibliography-notes "~/org/")


(use-package! org-ref
:config
(setq
         org-ref-completion-library 'org-ref-helm-cite
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         bibtex-completion-bibliography (list bibliography-path) ; org-ref-default-bibliography
         bibtex-completion-notes-path "~/org/bibnotes.org" ; org-ref-bibliography-notes
         org-ref-notes-directory bibliography-notes
         org-ref-notes-function 'orb-edit-notes
         ))




(after! helm
  (use-package! helm-bibtex
    :custom
    (bibtex-completion-bibliography (list bibliography-path))
    (bibtex-completion-pdf-field "file")
    ))



(map! :leader
      :desc "Open Bibliography manager"
      "o b" #'org-ref-insert-cite-link)


;;Latex Preview
;;
(map! :leader
      :desc "Toggle Latex Preview"
      "t L" #'org-latex-preview)

;; Latex Reference Manager
(setq reftex-default-bibliography (list bibliography-path))


;;emacs RefTeX
(setq reftex-ref-macro-prompt nil) ;skips picking the reference style
(setq reftex-refstyle "\\cref")


;; Alias Management
(map! :leader
      :desc "Add alias"
      "n r a" #'org-roam-alias-add)

;; Note edition
(map! :leader
      (:prefix ("n e" . "edit")

       :desc "Convert to heading" "h" #'org-toggle-heading
       :desc "Convert to checkbox" "t" #'org-todo
       :desc "Convert to item" "i" #'org-toggle-item
       :desc "Increase heading" "k" #'org-do-promote
       :desc "Decrease heading" "j" #'org-do-demote
       ))


;; Setup for TODOS
;;
(setq org-use-fast-todo-selection nil)
 (setq org-todo-keywords
  '((sequence "IDEA" "TODO" "DONE")))

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



;; Propose links to attachments in nodes
(setq org-attach-store-link-p 'attached)

;; Don't open files on drag n drop
;; (setq dnd-protocol-alist nil)

;; update buffers in dired when open


;; Agenda views
;;
(add-to-list 'org-agenda-custom-commands
             '("W" "Weekly review"
               agenda ""
               ((org-agenda-start-day "-14d")
                (org-agenda-span 14)
                (org-agenda-show-all-dates nil)
                ;;(org-agenda-start-on-weekday 1)
                (org-agenda-start-with-log-mode '(closed)))))


;; Org roam bibtex
(use-package! org-roam-bibtex
  :after (org-roam)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq orb-preformat-keywords '("citekey" "author" "year"))
  (require 'org-ref)
)

(org-roam-bibtex-mode)

;; disable annoying fontification in latex
(setq font-latex-fontify-script nil)


;; Load environment from shell
(exec-path-from-shell-initialize)

;; Setup variables for latex mode
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-after-compilation-finished-functions nil) ;; Do no open PDFs after compilation
            (setq-default TeX-master nil) ;; Ask for master file if not specified
            (setq TeX-auto-save t)
            (setq TeX-parse-self t) ;; Parse files to look for local variables (including master file definition)
            ;; Use the 'open' command to read PDF -> leads to preview by default
            (setq TeX-view-program-list '(("Preview" "open %o")))
            (setq TeX-view-program-selection '((output-pdf "Preview")))
            ;; Define a new command to remove ALL auxiliary files (not only those of the master file)
            (add-to-list 'TeX-command-list
                         '("Clean ALL"
                           "latexmk -C *.tex"
                           TeX-run-command
                           nil                              ; ask for confirmation
                           t                                ; active in all modes
                           :help "Delete all latex auxiliary files, including for others than the master file")
                         )
            )
)

