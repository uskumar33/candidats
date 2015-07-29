<?php

include_once('./lib/phpmailernew/PHPMailerAutoload.php');
include_once('./lib/phpmailernew/class.phpmailer.php');
include_once('./lib/phpmailernew/class.smtp.php');

$mail = new PHPMailerNew;

$mail->SMTPDebug = 3;                               // Enable verbose debug output
$mail->isSMTP();                                      // Set mailer to use SMTP
$mail->Host = 'smtp.gmail.com';  // Specify main and backup SMTP servers
$mail->SMTPAuth = true;                               // Enable SMTP authentication
$mail->Username = 'deltatestuser@deltaintech.com';                 // SMTP username
$mail->Password = 'Delta@3456';                           // SMTP password
$mail->SMTPSecure = 'ssl';                            // Enable TLS encryption, `ssl` also accepted
$mail->Port = 465;                                    // TCP port to connect to

$mail->From = 'deltatestuser@deltaintech.com';
$mail->FromName = 'Suresh';
$mail->addAddress('sudatha@deltaintech.com', 'Suresh-Delta');     // Add a recipient
$mail->isHTML(true);                                  // Set email format to HTML

$mail->Subject = 'Here is the subject';
$mail->Body = 'This is the HTML message body <b>in bold!</b>';
$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

if (!$mail->send()) {
    echo 'Message could not be sent.';
    echo 'Mailer Error: ' . $mail->ErrorInfo;
} else {
    echo 'Message has been sent';
}
