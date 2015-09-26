<?php /* $Id: Add.tpl 3746 2007-11-28 20:28:21Z andrew $ */ ?>
<?php if ($this->isModal): ?>
<?php TemplateUtility::printModalHeader('Candidates', array('modules/candidates/validator.js', 'modules/candidates/dynamicskillscertificates.js','js/addressParser.js', 'js/listEditor.js',  'js/candidate.js', 'js/candidateParser.js'), 'Add New Candidate to This Job Order Pipeline'); ?>
<?php else: ?>
<?php TemplateUtility::printHeader('Candidates', array('modules/candidates/validator.js', 'modules/candidates/dynamicskillscertificates.js', 'js/addressParser.js', 'js/listEditor.js',  'js/candidate.js', 'js/candidateParser.js')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active, $this->subActive); ?>
<div id="main">

    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">

        <table>
            <tr>
                <td width="3%">
                    <img src="images/candidate.gif" width="24" height="24" alt="Candidates" style="border: none; margin-top: 3px;" />&nbsp;
                </td>
                <td><h2>Candidates: Add Candidate</h2></td>
            </tr>
        </table>

        <?php endif; ?>

        <p class="note<?php if ($this->isModal): ?>Unsized<?php endif; ?>">Basic Information</p>

        <table style="font-weight:bold; border: 1px solid #000; background-color: #ffed1a; padding:5px; display:none; margin-bottom:7px;" width="<?php if ($this->isModal): ?>100%<?php else: ?>925<?php endif; ?>" id="candidateAlreadyInSystemTable">
            <tr>
                <td class="tdVertical">
                    This profile may already be in the system.&nbsp;&nbsp;Possible duplicate candidate profile:&nbsp;&nbsp;
                    <a href="javascript:void(0);" onclick="window.open('<?php echo(CATSUtility::getIndexName()); ?>?m=candidates&amp;a=show&amp;candidateID=' + candidateIsAlreadyInSystemID);">
                        <img src="images/new_window.gif" border="0" />
                        <img src="images/candidate_small.gif" border="0" />
                        <span id="candidateAlreadyInSystemName"></span>
                    </a>
                </td>
            </tr>
        </table>

        <?php if ($this->isModal): ?>
        <?php $URI = CATSUtility::getIndexName() . '?m=joborders&amp;a=addCandidateModal&jobOrderID=' . $this->jobOrderID; ?>
        <?php else: ?>
        <?php $URI = CATSUtility::getIndexName() . '?m=candidates&amp;a=add'; ?>
        <?php endif; ?>

        <form name="addCandidateForm" id="addCandidateForm" enctype="multipart/form-data" action="<?php echo($URI); ?>" method="post" onsubmit="return (checkAddForm(document.addCandidateForm) && onSubmitEmailInSystem());" autocomplete="off" enctype="multipart/form-data">
            <?php if ($this->isModal): ?>
            <input type="hidden" name="jobOrderID" id="jobOrderID" value="<?php echo($this->jobOrderID); ?>" />
            <?php endif; ?>
            <input type="hidden" name="postback" id="postback" value="postback" />

            <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>925<?php endif; ?>">
                <tr>
                    <Td class="tdVertical" width="<?php if ($this->isModal): ?>50%<?php else: ?>450<?php endif; ?>">
                        <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>450<?php endif; ?>">
                            <?php if ($this->isParsingEnabled): ?>
                            <tr>
                                <td class="tdVertical" colspan="2">
                                    <img src="images/parser/manual.gif" border="0" />
                                </td>
                                <td class="tdVertical">
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td align="left"><img src="images/parser/import.gif" border="0" /></td>
                                            <td align="right">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <?php endif; ?>
                            <tr>
                                <td class="tdVertical">
                                    <label id="firstNameLabel" for="firstName">First Name:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="1" name="firstName" id="firstName" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['firstName'])) $this->_($this->preassignedFields['firstName']); ?>" />&nbsp;*
                                </td>                                
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="lastNameLabel" for="lastName">Last Name:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="3" name="lastName" id="lastName" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['lastName'])) $this->_($this->preassignedFields['lastName']); ?>" />&nbsp;*
                                </td>
                            </tr>   
                            <tr>
                                <td colspan="2" class="tdData">
                                    <?php if (!$this->isParsingEnabled || $this->associatedAttachment != 0): ?>                       

                                    <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>150<?php endif; ?>">
                                        <tr>
                                            <td class="tdVertical">Resume:</td>
                                            <td class="tdData" style="width:200px;">
                                                <?php if ($this->associatedAttachment == 0): ?>
                                        <nobr> <?php /* FIXME:  remove nobr stuff */ ?>
                                            <?php if (isset($this->overAttachmentQuota)): ?>
                                            <span style="font-size:10px;">(You have already reached your limit of <?php echo(FREE_ACCOUNT_SIZE/1024); ?> MB of attachments, and cannot add additional file attachments without upgrading to CATS Professional Hosted.)<br /></font>Copy and Paste Resume:&nbsp;
                                                <?php else: ?>
                                                <input type="file" id="file" name="file" size="21"  <?php if($this->associatedTextResume !== false): ?>disabled<?php endif; ?> /> &nbsp;
                                                       <?php endif; ?>
                                                       <a href="javascript:void(0);" onclick="if (document.getElementById('textResumeTD').style.display != '') {
                                                                   document.getElementById('textResumeTD').style.display = '';
                                                                   document.getElementById('file').disabled = true;
                                                               } else {
                                                                   document.getElementById('textResumeTD').style.display = 'none';
                                                                   document.getElementById('file').disabled = false;
                                                               }">
                                                    <img src="images/package_editors.gif" style="margin:0px; padding:0px;"  class="absmiddle" alt="" height="22px" border="0" title="Copy / Paste Resume" />
                                                </a>
                                        </nobr>
                                        <?php else: ?>
                                        <a href="<?php echo $this->associatedAttachmentRS['retrievalURL']; ?>">
                                            <img src="<?php $this->_($this->associatedAttachmentRS['attachmentIcon']) ?>" alt="" width="16" height="16" style="border: none;" />
                                        </a>
                                        <a href="<?php echo $this->associatedAttachmentRS['retrievalURL']; ?>">
                                            <?php $this->_($this->associatedAttachmentRS['originalFilename']) ?>
                                        </a>
                                        <?php echo($this->associatedAttachmentRS['previewLink']); ?>
                                        <input type="hidden" name="associatedAttachment" value="<?php echo($this->associatedAttachment); ?>" />
                                        <?php endif; ?>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="3" align="left" valign="top">
                                    <input type="hidden" name="textResumeFilename" value="<?php if(isset($this->preassignedFields['textResumeFilename'])) $this->_($this->preassignedFields['textResumeFilename']); else echo('resume.txt'); ?>" />
                                    <div id="textResumeTD" <?php if($this->associatedTextResume === false): ?>style="display:none;"<?php endif; ?>>
                                         <p class="freeformtop" style="width: 150px;">Cut and paste resume text here.</p>

                                        &nbsp;<textarea class="inputbox" tabindex="46" name="textResumeBlock" id="textResumeBlock" rows="5" cols="30" style="width: 200px; height: 100px;"><?php if ($this->associatedTextResume !== false) $this->_($this->associatedTextResume); ?></textarea>

                                        <p class="freeformtop" style="width: 150px;">Cut and paste resume text here.</p>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <?php else: ?>
                        <br />
                        <?php endif; ?>
                    </td>
                </tr>
            </table>
            </Td>
            <Td class="tdVertical"  width="<?php if ($this->isModal): ?>50%<?php else: ?>450<?php endif; ?>">
                <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>450<?php endif; ?>">
                    <tr>
                        <td class="tdVertical">
                            <label id="currentlocationLabel" for="currentlocation">Current Location:</label>
                        </td>
                        <td class="tdData">
                            <input type="text" tabindex="23" name="currentlocation" id="currentlocation" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['lastName'])) $this->_($this->preassignedFields['lastName']); ?>" />&nbsp;*
                        </td>
                    </tr>

                    <tr>
                        <td class="tdVertical">
                            <label id="emailLabel" for="email1">E-Mail:</label>
                        </td>
                        <td class="tdData">
                            <input type="text" tabindex="6" name="email1" id="email1" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['email'])) $this->_($this->preassignedFields['email']); elseif (isset($this->preassignedFields['email1'])) $this->_($this->preassignedFields['email1']); ?>" onchange="checkEmailAlreadyInSystem(this.value);" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdVertical">
                            <label id="phoneCellLabel" for="phoneCell">Cell Phone:</label>
                        </td>
                        <td class="tdData">
                            <input type="text" tabindex="9" name="phoneCell" id="phoneCell" class="inputbox" style="width: 150px;" value="<?php if (isset($this->preassignedFields['phoneCell'])) $this->_($this->preassignedFields['phoneCell']); ?>" />
                        </td>
                    </tr>

                    <tr>
                        <td class="tdVertical">
                            <label id="JobOrderLabel" for="prefferedlocation">JobOrder:</label>
                        </td>
                        <td class="tdData">
                            <select id="JobOrderID" name="JobOrderID" class="inputbox" style="width: 150px;">
                                <option value="-1">-Select from List-</option>
                                <?php if ($this->allJobOrders !== false): ?>
                                <?php foreach ($this->allJobOrders as $rowNumber => $contactsData): ?>
                                <option value="<?php $this->_($contactsData['id']) ?>"><?php $this->_($contactsData['title']) ?></option>
                                <?php endforeach; ?>
                                <?php endif; ?>
                            </select>
                        </td>
                    </tr>

                </table>
            </Td>
            </tr>
            <tr>
                <td colspan="2" class="tdVertical">
                    <div align="right" style="margin-top: 0px; margin-right: 50px; margin-bottom: 5px;">
                        <input type="submit" class="button" value="Add Candidate" />
                    </div>
                </td>
            </tr>
            </table>
            <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>925<?php endif; ?>">
                <tr>
                    <Td class="tdVertical" width="<?php if ($this->isModal): ?>50%<?php else: ?>450<?php endif; ?>">
                        <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>450<?php endif; ?>">
                            <?php if ($this->isParsingEnabled): ?>
                            <tr>
                                <td class="tdVertical" colspan="2">
                                    <img src="images/parser/manual.gif" border="0" />
                                </td>
                                <td class="tdVertical">
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td align="left"><img src="images/parser/import.gif" border="0" /></td>
                                            <td align="right">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <?php endif; ?>


                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="middleNameLabel" for="middleName">Middle Name:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="2" name="middleName" id="middleName" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['middleName'])) $this->_($this->preassignedFields['middleName']); ?>" />
                                </td>
                            </tr>                         

                            <tr>
                                <td class="tdVertical">
                                    <label id="sexlabel" for="sex">Sex:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="4" id="sex" name="sex" class="inputbox" style="width: 150px;">
                                        <option value="M">Male</option>
                                        <option value="F">Female</option>
                                        <option value="O">Others</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="startDateLabel" for="startDate">DOB :</label>
                                </td>
                                <td class="tdData">
                                    <?php if (!empty($this->data['startDate'])): ?>
                                    <script type="text/javascript">DateInput('dob', false, 'MM-DD-YYYY', '<?php echo($this->data['dob']); ?>', 9);</script>
                                    <?php else: ?>
                                    <script type="text/javascript">DateInput('dob', false, 'MM-DD-YYYY', '', 9);</script>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="prefferedlocationLabel" for="prefferedlocation">Preffered Location:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="24" name="prefferedlocation" id="prefferedlocation" class="inputbox" style="width: 150px" value="" />
                                </td>
                            </tr>


                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="email2Label" for="email2">2nd E-Mail:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="7" name="email2" id="email2" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['email2'])) $this->_($this->preassignedFields['email2']); ?>" />
                                </td>
                            </tr>

                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="webSiteLabel" for="webSite">Web Site:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="8" name="webSite" id="webSite" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['webSite'])) $this->_($this->preassignedFields['webSite']); ?>" />
                                </td>
                            </tr>


                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="phoneHomeLabel" for="phoneHome">Home Phone:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="10" name="phoneHome" id="phoneHome" class="inputbox" style="width: 150px;" value="<?php if (isset($this->preassignedFields['phoneHome'])) $this->_($this->preassignedFields['phoneHome']); ?>" />
                                    <?php if ($this->isParsingEnabled): ?>
                                    <?php if ($this->parsingStatus['parseLimit'] >= 0 && $this->parsingStatus['parseUsed'] >= $this->parsingStatus['parseLimit']): ?>
                                    &nbsp;
                                    <?php else: ?>
                                    <?php if ($this->isModal): ?>&nbsp;&nbsp;<?php else: ?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php endif; ?>
                                    <img id="transfer" src="images/parser/transfer<?php echo ($this->contents != '' ? '' : '_grey'); ?>.gif" <?php echo ($this->contents != '' ? 'style="cursor: pointer;"' : ''); ?> border="0" alt="Import Resume" onclick="parseDocumentFileContents();" />
                                         <?php endif; ?>
                                         <?php else: ?>
                                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="arrowButton" tabindex="11" align="middle" type="button" value="&lt;--" class="arrowbutton" onclick="AddressParser_parse('addressBlock', 'person', 'addressParserIndicator', 'arrowButton');
                                                 document.addCandidateForm.firstName.focus();" />
                                    <?php endif; ?>
                                </td>
                            </tr>               

                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="phoneWorkLabel" for="phoneWork">Work Phone:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="12" name="phoneWork" id="phoneWork" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['phoneWork'])) $this->_($this->preassignedFields['phoneWork']); ?>" />
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="panlabel" for="pan">PAN:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="14" name="pan" id="pan" class="inputbox" style="width: 150px" value="" />
                                </td>
                            </tr>

                            <tr >
                                <td class="tdVertical">
                                    <label id="validpassportlabel" for="ValidPassport">Valid Passport:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="15" id="validpassport" name="validpassport" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="skypeidlabel" for="skypeid">Skype ID:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="13" name="skypeid" id="skypeid" class="inputbox" style="width: 150px" value="" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="currentemployerlabel" for="currentemployer">Current Employer:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="30" name="currentemployer" id="currentemployer" class="inputbox" style="width: 150px;" value="<?php if (isset($this->preassignedFields['phoneHome'])) $this->_($this->preassignedFields['phoneHome']); ?>" />
                                </td>
                            </tr>    


                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="addressLabel" for="address">Address:</label>
                                </td>
                                <td class="tdData">
                                    <textarea tabindex="15" name="address" id="address" rows="2" cols="40" class="inputbox" style="width: 150px"><?php if(isset($this->preassignedFields['address'])) $this->_($this->preassignedFields['address']); if(isset($this->preassignedFields['address2'])) $this->_("\n" . $this->preassignedFields['address2']); ?></textarea>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/indicator2.gif" id="addressParserIndicator" alt="" style="visibility: hidden; margin-left: 10px;" height="16" width="16" />
                                </td>
                            </tr>

                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="cityLabel" for="city">City:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="16" name="city" id="city" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['city'])) $this->_($this->preassignedFields['city']); ?>" />
                                </td>
                            </tr>

                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="stateLabel" for="state">State:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="17" name="state" id="state" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['state'])) $this->_($this->preassignedFields['state']); ?>" />
                                </td>
                            </tr>

                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="zipLabel" for="zip">Postal Code:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="18" name="zip" id="zip" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['zip'])) $this->_($this->preassignedFields['zip']); ?>" />&nbsp;
                                    <input type="button" tabindex="19" onclick="CityState_populate('zip', 'ajaxIndicator');" value="Lookup" />
                                    <img src="images/indicator2.gif" alt="AJAX" id="ajaxIndicator" style="vertical-align: middle; visibility: hidden; margin-left: 5px;" />
                                </td>
                            </tr>

                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="stateLabel" for="state">Best Time to Call:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="20" name="bestTimeToCall" id="bestTimeToCall" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['bestTimeToCall'])) $this->_($this->preassignedFields['bestTimeToCall']); ?>" />
                                </td>
                            </tr>

                            <?php $tabIndex = 21; ?>
                        </table>
                    </Td>
                    <Td class="tdVertical"  width="<?php if ($this->isModal): ?>50%<?php else: ?>450<?php endif; ?>">
                        <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>450<?php endif; ?>">


                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="totalexplabel" for="totalexp">Total Exp:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="22" name="totalexp" id="totalexp" class="inputbox" style="width: 150px" value="<?php if(isset($this->preassignedFields['middleName'])) $this->_($this->preassignedFields['middleName']); ?>" />
                                </td>
                            </tr>


                            <tr>
                                <td class="tdVertical">
                                    <label id="currentdesignationLabel" for="currentdesignation">Current Designation:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="25" name="currentdesignation" id="currentdesignation" class="inputbox" style="width: 150px" value="" />
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="currentctclabel" for="currentctc">Current CTC:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="31" name="currentCTC" id="currentCTC" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['phoneWork'])) $this->_($this->preassignedFields['phoneWork']); ?>" />
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="expectedctclabel" for="expectedctc">Expected CTC:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="32" name="expectedCTC" id="expectedCTC" class="inputbox" style="width: 150px" value="" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="durationLabel" for="duration">Total years of Exp.</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="32" name="expyearsstart" id="expyearsstartID" class="inputbox" style="width: 150px" value="" />
                                </td>                                  
                            </tr>
                            <tr style="display: none;">
                                <td class="tdVertical">
                                    <label id="employeetypelabel" for="employeetype">Employee Type:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="26" id="employeetype" name="employeetype" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="FullTime">FullTime</option>
                                        <option value="PartTime">PartTime</option>
                                        <option value="Others">Others</option>
                                    </select>
                                </td>
                            </tr>

                            <tr >
                                <td class="tdVertical">
                                    <label id="noticeperiodlabel" for="noticeperiod">Notice Period:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="27" id="noticeperiod" name="noticeperiod" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="Immediate">Immediate</option>
                                        <option value="7 days">7 days</option>
                                        <option value="15 days">15 days</option>
                                        <option value="30 days">30 days</option>
                                        <option value="2 Month">2 Month</option>
                                        <option value="3 Month">3 Month</option>
                                        <option value="Greater than 3 Month">Greater than 3 Month</option>
                                    </select>
                                </td>
                            </tr>

                            <tr >
                                <td class="tdVertical">
                                    <label id="reasonsforchangelabel" for="reasonsforchange">Reasons for change:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="28" id="reasonsforchange" name="reasonsforchange" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="Better opportunity">Better opportunity</option>
                                        <option value="Location constraint">Location constraint</option>
                                        <option value="On-site opportunity">On-site opportunity</option>
                                        <option value="Salary">Salary</option>
                                        <option value="Others">Others</option>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="anyoffersinhandlabel" for="anyoffersinhand">Any Offers in hand:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="29" id="anyoffersinhand" name="anyoffersinhand" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="Y">Yes</option>
                                        <option value="N">No</option>
                                    </select>
                                </td>
                            </tr>

                        </table>
                    </Td>

                </tr>
            </table>


            <br>
            <?php 
            if ($this->jobOrderID<=0) {
            ?>
            <p class="note">Candidate Experience </p>

            <table class="editTable" width="925">               
                <tr>
                    <td colspan="5" class="tdVertical">
                        <br>
                        <input type="button" width=250px" class="button" name="btnmandatoryskills"  value="Technical Experience"  />                        
                    </td>
                </tr>
                <tr>
                    <td colspan="5" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="900" id="mytab1">
                                <tr>
                                    <td class="tdData">
                                        <label id="durationLabel" for="duration" style="width: 100px;">Skill </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="mandatoryskillname" name="mandatoryskillname[]" 
                                               style="width: 150px;" value="">
                                    </td> 
                                    <td class="tdData">
                                        <label id="durationLabel" for="duration"># Projects Handled </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="projectshandled" name="projectshandled[]" 
                                               style="width: 100px;" value="">
                                    </td> 
                                    <td class="tdData">
                                        <label id="durationLabel" for="duration">Duration </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="duration" name="duration[]" 
                                               style="width: 50px;" value="">
                                    </td> 

                                    <td>
                                        <input  type="button" class="button" value="Add" onclick="mytab1addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab1')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="5" class="tdVertical">
                        <br>
                        <input type="button" class="button" name="btnoptionalskills"  value="Domain Knowledge"  />
                    </td>
                </tr>
                <tr>
                    <td colspan="5" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="900" id="mytab2">
                                <tr>
                                    <td class="tdData">
                                        <label id="durationLabel" for="duration" style="width: 100px;">Domain </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="domainname" name="domainname[]" 
                                               style="width: 150px;" value="">
                                    </td> 
                                    <td class="tdData">
                                        <label id="durationLabel" for="duration">Client </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="clientname" name="clientname[]" 
                                               style="width: 100px;" value="">
                                    </td> 
                                    <td class="tdData">
                                        <label id="durationLabel" for="duration">Duration </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="domainduration" name="domainduration[]" 
                                               style="width: 50px;" value="">
                                    </td> 
                                    <td>
                                        <input  type="button" class="button" value="Add" onclick="mytab2addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab2')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
            <p class="note" style="display:none;">Certifications</p>
            <table  style="display:none;" class="editTable" width="925">                
                <tr>
                    <td colspan="4" class="tdVertical">
                        <br>
                        <input type="button" width=250px" class="button" name="btnmandatoryskills"  value="Add Certifications (if any)"  />                        
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="900" id="mytab3">
                                <tr>
                                    <td class="tdVertical">
                                        <label id="durationLabel" for="duration">Certification 1</label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="39" class="inputbox" id="certificationname" name="certificationname[]" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID"></label>
                                    </td>
                                    <td class="tdData">
                                        <select tabindex="40" id="certificationcategory" name="certificationcategory[]" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                            <option value="1">Mandatory</option>
                                            <option value="0">Optional</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="button" class="button" value="Add" onclick="mytab3addRow(this)">
                                        <input type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab3')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>               
            </table>
            <br>
            <?php 
            }
            else{
            ?>
            <p class="note">Key Skills: </p>

            <table class="editTable" width="750">
                <tr>
                    <td colspan="4" class="tdVertical">
                        <br>
                        <input type="button" class="button" name="btnoptionalskills"  value="Add additional skillset (if any)"  />
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <!-- Skills added in JobOrder -->
                        <table class="editTable" width="900">
                            <?php
                            foreach ($this->jobOrderSkills as $emp_option) {
                            ?>
                            <tr>
                                <td class="tdData">
                                    <input type="text" tabindex="41" class="inputbox" id="optionalskillname" name="optionalskillname[]" 
                                           style="width: 150px;" value="<?php echo $emp_option; ?>">
                                </td>                               
                                <td class="tdData">
                                    <select tabindex="42" id="optionalskillnameexp" name="optionalskillnameexp[]" class="inputbox" style="width: 100px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="1"><1</option>
                                        <option value="2"><2</option>
                                        <option value="3"><3</option>
                                        <option value="4"><4</option>
                                        <option value="5"><5</option>
                                        <option value="6"><6</option>
                                        <option value="7"><7</option>
                                        <option value="8"><8</option>
                                        <option value="9"><9</option>
                                        <option value="10"><10</option>
                                        <option value="11">>10</option>
                                    </select>
                                </td>
                            </tr>
                            <?php
                            }
                            ?>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="750" id="mytab21">
                                <tr>
                                    <td class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="43" class="inputbox" id="optionalskillname" name="optionalskillname[]" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">Exp.</label>
                                    </td>
                                    <td class="tdData">
                                        <select tabindex="44" id="optionalskillnameexp" name="optionalskillnameexp[]" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                            <option value="1"><1</option>
                                            <option value="2"><2</option>
                                            <option value="3"><3</option>
                                            <option value="4"><4</option>
                                            <option value="5"><5</option>
                                            <option value="6"><6</option>
                                            <option value="7"><7</option>
                                            <option value="8"><8</option>
                                            <option value="9"><9</option>
                                            <option value="10"><10</option>
                                            <option value="11">>10</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input  type="button" class="button" value="Add" onclick="mytab21addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab21')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
            <p class="note">Certifications</p>
            <table class="editTable" width="750">                
                <tr>
                    <td colspan="4" class="tdVertical">
                        <br>
                        <input type="button" width=250px" class="button" name="btnmandatoryskills"  value="Add Certifications (if any)"  />                        
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <!-- Certifications added in JobOrder -->
                        <table class="editTable" width="900">
                            <?php
                            foreach ($this->jobOrderCertifications as $emp_option) {
                            ?>
                            <tr>
                                <td class="tdData">
                                    <label id="openingsIDLabel" for="openingsID"><?php echo $emp_option; ?></label>
                                </td>
                            </tr>
                            <?php
                            }
                            ?>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="750" id="mytab31">
                                <tr>
                                    <td class="tdVertical">
                                        <label id="durationLabel" for="duration">Certification </label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="45" class="inputbox" id="certificationname" name="certificationname[]" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td class="tdVertical">

                                    </td>
                                    <td class="tdData">

                                    </td>
                                    <td>
                                        <input type="button" class="button" value="Add" onclick="mytab31addRow(this)">
                                        <input type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab31')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>               
            </table>
            <br>
            <?php 
            //echo $this->MyTestData;
            }
            ?>


            <?php if($this->EEOSettingsRS['enabled'] == 1): ?>
            <p class="note<?php if ($this->isModal): ?>Unsized<?php endif; ?>" style="margin-top: 5px;">EEO Information</p>
            <table class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>925<?php endif; ?>">
                <?php if ($this->EEOSettingsRS['genderTracking'] == 1): ?>
                <tr>
                    <td class="tdVertical">
                        <label id="canRelocateLabel" for="canRelocate">Gender:</label>
                    </td>
                    <td class="tdData">
                        <select id="gender" name="gender" class="inputbox" style="width:200px;" tabindex="<?php echo($tabIndex++); ?>">
                            <option selected="selected" value="">----</option>
                            <option value="M"<?php if (isset($this->preassignedFields['gender']) && $this->preassignedFields['gender'] == 'M') echo ' selected'; ?>>Male</option>
                            <option value="F"<?php if (isset($this->preassignedFields['gender']) && $this->preassignedFields['gender'] == 'F') echo ' selected'; ?>>Female</option>
                        </select>
                    </td>
                </tr>
                <?php endif; ?>
                <?php if ($this->EEOSettingsRS['ethnicTracking'] == 1): ?>
                <tr>
                    <td class="tdVertical">
                        <label id="canRelocateLabel" for="canRelocate">Ethnic Background:</label>
                    </td>
                    <td class="tdData">
                        <select id="race" name="race" class="inputbox" style="width:200px;" tabindex="<?php echo($tabIndex++); ?>">
                            <option selected="selected" value="">----</option>
                            <option value="1"<?php if (isset($this->preassignedFields['race']) && $this->preassignedFields['race'] == '1') echo ' selected'; ?>>American Indian</option>
                            <option value="2"<?php if (isset($this->preassignedFields['race']) && $this->preassignedFields['race'] == '2') echo ' selected'; ?>>Asian or Pacific Islander</option>
                            <option value="3"<?php if (isset($this->preassignedFields['race']) && $this->preassignedFields['race'] == '3') echo ' selected'; ?>>Hispanic or Latino</option>
                            <option value="4"<?php if (isset($this->preassignedFields['race']) && $this->preassignedFields['race'] == '4') echo ' selected'; ?>>Non-Hispanic Black</option>
                            <option value="5"<?php if (isset($this->preassignedFields['race']) && $this->preassignedFields['race'] == '5') echo ' selected'; ?>>Non-Hispanic White</option>
                        </select>
                    </td>
                </tr>
                <?php endif; ?>
                <?php if ($this->EEOSettingsRS['veteranTracking'] == 1): ?>
                <tr>
                    <td class="tdVertical">
                        <label id="canRelocateLabel" for="canRelocate">Veteran Status:</label>
                    </td>
                    <td class="tdData">
                        <select id="veteran" name="veteran" class="inputbox" style="width:200px;" tabindex="<?php echo($tabIndex++); ?>">
                            <option selected="selected" value="">----</option>
                            <option value="1"<?php if (isset($this->preassignedFields['veteran']) && $this->preassignedFields['veteran'] == '1') echo ' selected'; ?>>No</option>
                            <option value="2"<?php if (isset($this->preassignedFields['veteran']) && $this->preassignedFields['veteran'] == '2') echo ' selected'; ?>>Eligible Veteran</option>
                            <option valie="3"<?php if (isset($this->preassignedFields['veteran']) && $this->preassignedFields['veteran'] == '3') echo ' selected'; ?>>Disabled Veteran</option>
                            <option value="4"<?php if (isset($this->preassignedFields['veteran']) && $this->preassignedFields['veteran'] == '4') echo ' selected'; ?>>Eligible and Disabled</option>
                        </select>
                    </td>
                </tr>
                <?php endif; ?>
                <?php if ($this->EEOSettingsRS['disabilityTracking'] == 1): ?>
                <tr>
                    <td class="tdVertical">
                        <label id="canRelocateLabel" for="canRelocate">Disability Status:</label>
                    </td>
                    <td class="tdData">
                        <select id="disability" name="disability" class="inputbox" style="width:200px;" tabindex="<?php echo($tabIndex++); ?>">
                            <option selected="selected" value="">----</option>
                            <option value="No"<?php if (isset($this->preassignedFields['disability']) && $this->preassignedFields['disability'] == 'No') echo ' selected'; ?>>No</option>
                            <option value="Yes"<?php if (isset($this->preassignedFields['disability']) && $this->preassignedFields['disability'] == 'Yes') echo ' selected'; ?>>Yes</option>
                        </select>
                    </td>
                </tr>
                <?php endif; ?>
            </table>
            <br />
            <?php endif; ?>

            <p  class="note<?php if ($this->isModal): ?>Unsized<?php endif; ?>" style="margin-top: 5px;">Other</p>
            <table  class="editTable" width="<?php if ($this->isModal): ?>100%<?php else: ?>925<?php endif; ?>">

                <?php for ($i = 0; $i < count($this->extraFieldRS); $i++): ?>
                <tr style="display:none;">
                    <td class="tdVertical" id="extraFieldTd<?php echo($i); ?>">
                        <label id="extraFieldLbl<?php echo($i); ?>">
                            <?php $this->_($this->extraFieldRS[$i]['fieldName']); ?>:
                        </label>
                    </td>
                    <td class="tdData" id="extraFieldData<?php echo($i); ?>">
                        <?php echo($this->extraFieldRS[$i]['addHTML']); ?>
                    </td>
                </tr>
                <?php endfor; ?>

                <tr style="display:none;">
                    <td class="tdVertical">
                        <label id="canRelocateLabel" for="canRelocate">Can Relocate:</label>
                    </td>
                    <td class="tdData">
                        <input type="checkbox" tabindex="<?php echo($tabIndex++); ?>" id="canRelocate" name="canRelocate" value="1"<?php if (isset($this->preassignedFields['canRelocate']) && $this->preassignedFields['canRelocate'] == '1') echo ' checked'; ?> />
                    </td>
                </tr>

                <tr style="display:none;">
                    <td class="tdVertical">
                        <label id="dateAvailableLabel" for="dateAvailable">Date Available:</label>
                    </td>
                    <td class="tdData">
                        <script type="text/javascript">DateInput('dateAvailable', false, 'MM-DD-YY', '', < ?php echo($tabIndex++); ? > );</script>

                        <?php /* DateInput()s take up 3 tabindexes. */ ?>
                        <?php $tabIndex += 2; ?>
                    </td>
                </tr>

                <tr style="display:none;">
                    <td class="tdVertical">
                        <label id="currentEmployerLabel" for="currentEmployer">Current Employer:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="<?php echo($tabIndex++); ?>" name="currentEmployer" id="currentEmployer" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['currentEmployer'])) $this->_($this->preassignedFields['currentEmployer']); ?>" />
                    </td>
                </tr>

                <tr style="display:none;">
                    <td class="tdVertical">
                        <label id="currentPayLabel" for="currentEmployer">Current Pay:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="<?php echo($tabIndex++); ?>" name="currentPay" id="currentPay" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['currentPay'])) $this->_($this->preassignedFields['currentPay']); ?>" />
                    </td>
                </tr>

                <tr style="display:none;">
                    <td class="tdVertical">
                        <label id="desiredPayLabel" for="currentEmployer">Desired Pay:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="<?php echo($tabIndex++); ?>" name="desiredPay" id="desiredPay" class="inputbox" style="width: 150px" value="<?php if (isset($this->preassignedFields['desiredPay'])) $this->_($this->preassignedFields['desiredPay']); ?>" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="othercertificationsLabel" for="othercertifications">Certifications</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="othercertifications" id="othercertifications" style="width: 400px;" value="" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="othercommunicationsLabel" for="othercommunications">Communication</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="othercommunications" id="othercommunications" style="width: 400px;" value="" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="clientintegrationLabel" for="keySkills">Client Interation</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="clientintegration" id="clientintegration" style="width: 400px;" value="" />
                    </td>
                </tr>
                <tr>
                    <td class="tdVertical">
                        &nbsp;
                    </td>
                    <td class="tdData">

                    </td>
                </tr>
                <tr>
                    <td class="tdVertical">
                        <label id="sourceLabel" for="sourceSelect">Source:</label>
                    </td>
                    <td class="tdData">
                        <?php if ($this->isModal): ?>
                        <select id="sourceSelect" tabindex="<?php echo($tabIndex++); ?>" name="source" class="inputbox" style="width: 150px;">
                            <?php else: ?>
                            <select id="sourceSelect" tabindex="<?php echo($tabIndex++); ?>" name="source" class="inputbox" style="width: 150px;" onchange="if (this.value == 'edit') {
                                                listEditor('Sources', 'sourceSelect', 'sourceCSV', false);
                                                this.value = '(none)';
                                            }
                                            if (this.value == 'nullline') {
                                                this.value = '(none)';
                                            }">
                                <option value="edit">(Edit Sources)</option>
                                <option value="nullline">-------------------------------</option>
                                <?php endif; ?>
                                <option value="(none)" <?php if (!isset($this->preassignedFields['source'])): ?>selected="selected"<?php endif; ?>>(None)</option>
                                <?php if (isset($this->preassignedFields['source'])): ?>
                                <option value="<?php $this->_($this->_($this->preassignedFields['source'])); ?>" selected="selected"><?php $this->_($this->_($this->preassignedFields['source'])); ?></option>
                                <?php endif; ?>
                                <?php foreach ($this->sourcesRS AS $index => $source): ?>
                                <option value="<?php $this->_($source['name']); ?>"><?php $this->_($source['name']); ?></option>
                                <?php endforeach; ?>
                            </select>
                            <input type="hidden" id="sourceCSV" name="sourceCSV" value="<?php $this->_($this->sourcesString); ?>" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="keySkillsLabel" for="keySkills">Key Skills:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" tabindex="<?php echo($tabIndex++); ?>" name="keySkills" id="keySkills" style="width: 400px;" value="<?php if (isset($this->preassignedFields['keySkills'])) $this->_($this->preassignedFields['keySkills']); ?>" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="notesLabel" for="notes">Misc. Notes:</label>
                    </td>
                    <td class="tdData">
                        <textarea class="inputbox" tabindex="<?php echo($tabIndex++); ?>" name="notes" id="notes" rows="5" cols="40" style="width: 400px;"><?php if (isset($this->preassignedFields['notes'])) $this->_($this->preassignedFields['notes']); ?></textarea>
                    </td>
                </tr>
            </table>

            <input type="submit" tabindex="<?php echo($tabIndex++); ?>" class="button" value="Add Candidate" />&nbsp;
            <input type="reset"  tabindex="<?php echo($tabIndex++); ?>" class="button" value="Reset" />&nbsp;
            <?php if ($this->isModal): ?>
            <input type="button" tabindex="<?php echo($tabIndex++); ?>" class="button" value="Back to Search" onclick="javascript:goToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=considerCandidateSearch&amp;jobOrderID=<?php echo($this->jobOrderID); ?>');" />
            <?php else: ?>
            <input type="button" tabindex="<?php echo($tabIndex++); ?>" class="button" value="Back to Candidates" onclick="javascript:goToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=candidates');" />
            <?php endif; ?>
        </form>

        <script type="text/javascript">
            document.addCandidateForm.firstName.focus();
                    < ?php if (isset($this - > preassignedFields['email']) || isset($this - > preassignedFields['email1'])): ? >
                    checkEmailAlreadyInSystem(urlDecode("<?php if(isset($this->preassignedFields['email'])) echo(urlencode($this->preassignedFields['email'])); else if(isset($this->preassignedFields['email1'])) echo(urlencode($this->preassignedFields['email1'])); ?>"));
                    < ?php endif; ? >
        </script>

        <?php if ($this->isModal): ?>
        </body>
        </html>
        <?php else: ?>
    </div>
</div>
<div id="bottomShadow"></div>
<?php TemplateUtility::printFooter(); ?>
<?php endif; ?>
