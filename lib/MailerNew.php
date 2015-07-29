<?php

$errorReporting = error_reporting();
error_reporting($errorReporting & ~ E_STRICT);
error_reporting($errorReporting);

include_once('./lib/phpmailernew/PHPMailerAutoload.php');
include_once('./lib/phpmailernew/class.phpmailer.php');
include_once('./lib/phpmailernew/class.smtp.php');

// FIXME: Remove this dependency! Bad bad bad!
include_once('./lib/Pipelines.php');

/* define('MAILER_MODE_DISABLED', 0);
  define('MAILER_MODE_PHP', 1);
  define('MAILER_MODE_SENDMAIL', 2);
  define('MAILER_MODE_SMTP', 3); */

class MailerNew {

    private $_mailer;
    private $_errorMessage = '';
    private $_settings;
    private $_siteID;
    private $_userID;
    private $_db;

    public function __construct($siteID, $userID = -1) {
        $this->_siteID = $siteID;

        $this->_mailer = new PHPMailerNew();
        $this->_mailer->SMTPDebug = 0;                               // Enable verbose debug output
        $this->_mailer->isSMTP();                                      // Set mailer to use SMTP

        /* $this->_mailer->Host = 'smtp.gmail.com';  // Specify main and backup SMTP servers
          $this->_mailer->SMTPAuth = true;                               // Enable SMTP authentication
          $this->_mailer->Username = 'deltatestuser@deltaintech.com';                 // SMTP username
          $this->_mailer->Password = 'Delta@3456';                           // SMTP password
          $this->_mailer->SMTPSecure = 'ssl';                            // Enable TLS encryption, `ssl` also accepted
          $this->_mailer->Port = 465; */

        $this->_mailer->Host = MAIL_SMTP_HOST;
        $this->_mailer->SMTPAuth = MAIL_SMTP_AUTH;
        $this->_mailer->Username = MAIL_SMTP_USER;
        $this->_mailer->Password = MAIL_SMTP_PASS;
        $this->_mailer->SMTPSecure = MAIL_SMTP_SECURE;
        $this->_mailer->Port = MAIL_SMTP_PORT;

        $this->_mailer->PluginDir = './lib/phpmailernew/';

        /* Load mailer configuration settings. */
        $settings = new MailerSettingsNew($this->_siteID);
        $this->_settings = $settings->getAll();

        /* Configure PHPMailer based on CATS configuration settings. */
        #$this->refreshSettings();

        $this->_mailer->SetLanguage('en', './lib/phpmailer/language/');

        if ($userID != -1) {
            $this->_userID = $userID;
        } else {
            $this->_userID = $_SESSION['CATS']->getUserID();
        }

        $this->_db = DatabaseConnection::getInstance();
    }

    public function sendToOne($recipient, $subject, $body, $isHTML = false, $logMessage = true, $replyTo = array(), $wrapLinesAt = 78) {
        return $this->send(
                        array($this->_settings['fromAddress'], ''), array($recipient), $subject, $body, $isHTML, $logMessage, $replyTo, $wrapLinesAt, true
        );
    }

    public function sendToMany($recipients, $subject, $body, $isHTML = false, $logMessage = true, $replyTo = array(), $wrapLinesAt = 78) {
        return $this->send(
                        array($this->_settings['fromAddress'], ''), $recipients, $subject, $body, $isHTML, $logMessage, $replyTo, $wrapLinesAt, true
        );
    }

    public function send($from, $recipients, $subject, $body, $isHTML = false, $logMessage = true, $replyTo = array(), $wrapLinesAt = 78, $signature = true) {

        $this->_mailer->From = $from[0];
        $this->_mailer->FromName = $from[1];

        $this->_mailer->WordWrap = $wrapLinesAt;

        $this->_mailer->Subject = $subject;

        if ($isHTML) {
            $this->_mailer->isHTML(true);

            if ($signature) {
                $body .= "\n<br />\n<br /><span style=\"font-size: 10pt;\">Powered by <a href=\"http://www.catsone.com\" alt=\"CATS "
                        . "Applicant Tracking System\">CATS</a> (Free ATS)</span>";
            }

            $this->_mailer->Body = '<div style="font: normal normal 12px Arial, Tahoma, sans-serif">'
                    . str_replace('<br>', "<br />\n", str_replace('<br />', '<br>', str_replace("\n", "<br>", $body))) . '</div>';

            $this->_mailer->AltBody = strip_tags($body);
        } else {
            if ($signature) {
                $body .= "\n\nPowered by CATS (http://www.catsone.com) Free ATS";
            }

            $this->_mailer->isHTML(false);
            $this->_mailer->Body = $body;
        }

        $failedRecipients = array();
        foreach ($recipients as $key => $value) {
            $this->_mailer->AddAddress($recipients[$key][0], $recipients[$key][1]);

            if (!empty($replyTo)) {
                $this->_mailer->AddReplyTo($replyTo[0], $replyTo[1]);
            }

            if (!$this->_mailer->Send()) {
                $failedRecipients[] = array(
                    'recipient' => $recipients[$key],
                    'errorMessage' => $this->_mailer->ErrorInfo
                );
            } else if ($logMessage) {
                // FIXME: Log all recipients in one log entry?
                // FIXME: Make sure all callers are passing an array of e-mails and not just a CSV string...
                $this->logMessage($from[0], $recipients[$key][0], $subject, $body);
            }

            $this->_mailer->ClearAddresses();
            $this->_mailer->ClearAttachments();
        }

        if (!empty($failedRecipients)) {
            $this->_errorMessage = "Errors occurred while attempting to send mail to one or more provided addresses:\n\n";

            foreach ($failedRecipients as $key => $value) {
                $this->_errorMessage .= sprintf(
                        "%s (%s): %s\n", $failedRecipients[$key]['recipient'][0], $failedRecipients[$key]['recipient'][1], $failedRecipients[$key]['errorMessage']
                );
            }

            return false;
        }

        $this->_errorMessage = '';
        return true;
    }

    public function SendWithCCandBCC($from, $recipients, $CC, $BCC, $subject, $body, $isHTML = false, $logMessage = true, $replyTo = array(), $wrapLinesAt = 78, $signature = true) {

        $this->_mailer->From = $from[0];
        $this->_mailer->FromName = $from[1];
        $this->_mailer->WordWrap = $wrapLinesAt;
        $this->_mailer->Subject = $subject;

        if ($isHTML) {
            $this->_mailer->isHTML(true);

            if ($signature) {
                $body .= "\n<br />\n<br /><span style=\"font-size: 10pt;\">Powered by <a href=\"http://www.catsone.com\" alt=\"CATS "
                        . "Applicant Tracking System\">CATS</a> (Free ATS)</span>";
            }

            $this->_mailer->Body = '<div style="font: normal normal 12px Arial, Tahoma, sans-serif">'
                    . str_replace('<br>', "<br />\n", str_replace('<br />', '<br>', str_replace("\n", "<br>", $body))) . '</div>';

            $this->_mailer->AltBody = strip_tags($body);
        } else {
            if ($signature) {
                $body .= "\n\nPowered by CATS (http://www.catsone.com) Free ATS";
            }

            $this->_mailer->isHTML(false);
            $this->_mailer->Body = $body;
        }

        $failedRecipients = array();
        foreach ($recipients as $key => $value) {
            $this->_mailer->AddAddress($recipients[$key][0], $recipients[$key][1]);

            //Add CC
            foreach ($CC as $key => $value) {
                $this->_mailer->AddCC($CC[$key][0], $CC[$key][1]);
            }

            //Add BCC
            foreach ($BCC as $key => $value) {
                $this->_mailer->AddBCC($BCC[$key][0], $BCC[$key][1]);
            }

            if (!empty($replyTo)) {
                $this->_mailer->AddReplyTo($replyTo[0], $replyTo[1]);
            }

            if (!$this->_mailer->Send()) {
                $failedRecipients[] = array(
                    'recipient' => $recipients[$key],
                    'errorMessage' => $this->_mailer->ErrorInfo
                );
            } else if ($logMessage) {
                // FIXME: Log all recipients in one log entry?
                // FIXME: Make sure all callers are passing an array of e-mails and not just a CSV string...
                $this->logMessage($from[0], $recipients[$key][0], $subject, $body);
            }

            $this->_mailer->ClearAddresses();
            $this->_mailer->ClearAttachments();
        }

        if (!empty($failedRecipients)) {
            $this->_errorMessage = "Errors occurred while attempting to send mail to one or more provided addresses:\n\n";

            foreach ($failedRecipients as $key => $value) {
                $this->_errorMessage .= sprintf(
                        "%s (%s): %s\n", $failedRecipients[$key]['recipient'][0], $failedRecipients[$key]['recipient'][1], $failedRecipients[$key]['errorMessage']
                );
            }

            return false;
        }

        $this->_errorMessage = '';
        return true;
    }

    public function getError() {
        return $this->_errorMessage;
    }

    public function overrideSetting($setting, $value) {
        $this->_settings[$setting] = $value;
    }

    /* public function refreshSettings() {
      switch (MAIL_MAILER) {
      case MAILER_MODE_DISABLED:
      break;

      case MAILER_MODE_SENDMAIL:
      $this->_mailer->Mailer = 'sendmail';
      $this->_mailer->Sendmail = MAIL_SENDMAIL_PATH;
      break;

      case MAILER_MODE_SMTP:
      $this->_mailer->Mailer = 'smtp';
      $this->_mailer->Host = MAIL_SMTP_HOST;
      $this->_mailer->Port = MAIL_SMTP_PORT;

      if (MAIL_SMTP_AUTH == true) {
      $this->_mailer->SMTPAuth = MAIL_SMTP_AUTH;
      $this->_mailer->Username = MAIL_SMTP_USER;
      $this->_mailer->Password = MAIL_SMTP_PASS;
      } else {
      $this->_mailer->SMTPAuth = false;
      }

      $this->_mailer->Timeout = 10;
      break;

      case MAILER_MODE_PHP:
      default:
      $this->_mailer->Mailer = 'mail';
      break;
      }
      } */

    private function logMessage($from, $to, $subject, $body) {
        $messageText = sprintf("Subject: %s\n\nMessage:\n%s", $subject, $body);

        $sql = sprintf(
                "INSERT INTO email_history (
                from_address,
                recipients,
                text,
                user_id,
                site_id,
                date
            )
            VALUES (
                %s,
                %s,
                %s,
                %s,
                %s,
                NOW()
            )", $this->_db->makeQueryString($from), $this->_db->makeQueryString($to), $this->_db->makeQueryString($messageText), $this->_userID, $this->_siteID
        );

        $this->_db->query($sql);
    }

}

class MailerSettingsNew {

    private $_db;
    private $_siteID;

    public function __construct($siteID) {
        $this->_siteID = $siteID;
        $this->_db = DatabaseConnection::getInstance();
    }

    /**
     * Returns all mailer / e-mail settings for a site.
     *
     * @return array E-mail settings (setting => value).
     */
    public function getAll() {
        // FIXME: This is violating just about every OO design principal I can come up with :)

        /* Default values. */
        $pipelines = new Pipelines($this->_siteID);
        $statuses = $pipelines->getStatuses();

        $candidateJoborderStatusSendsMessage = array();
        foreach ($statuses as $status) {
            $candidateJoborderStatusSendsMessage[$status['statusID']] = $status['triggersEmail'];
        }

        $settings = array(
            'fromAddress' => 'noreply@yourdomain.com',
            'configured' => '0',
            'modeConfigurable' => '1',
            'candidateJoborderStatusSendsMessage' => serialize($candidateJoborderStatusSendsMessage)
        );

        $sql = sprintf(
                "SELECT
                settings.setting AS setting,
                settings.value AS value,
                settings.site_id AS siteID
            FROM
                settings
            WHERE
                settings.site_id = %s
            AND
                settings.settings_type = %s", $this->_siteID, SETTINGS_MAILER
        );
        $rs = $this->_db->getAllAssoc($sql);

        /* Override default settings with settings from the database. */
        foreach ($rs as $rowIndex => $row) {
            foreach ($settings as $setting => $value) {
                if ($row['setting'] == $setting) {
                    $settings[$setting] = $row['value'];
                }
            }
        }

        return $settings;
    }

    /**
     * Sets a mailer setting for a site.
     *
     * @param string Setting name.
     * @param string Setting value.
     * @return void
     */
    public function set($setting, $value) {
        /* Delete old setting. */
        $sql = sprintf(
                "DELETE FROM
                settings
            WHERE
                settings.setting = %s
            AND
                site_id = %s
            AND
                settings_type", $this->_db->makeQueryStringOrNULL($setting), $this->_siteID, SETTINGS_MAILER
        );
        $this->_db->query($sql);

        /* Add new setting. */
        $sql = sprintf(
                "INSERT INTO settings (
                setting,
                value,
                site_id,
                settings_type
            )
            VALUES (
                %s,
                %s,
                %s,
                %s
            )", $this->_db->makeQueryStringOrNULL($setting), $this->_db->makeQueryStringOrNULL($value), $this->_siteID, SETTINGS_MAILER
        );
        $this->_db->query($sql);
    }

}

?>
