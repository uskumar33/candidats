<?php /* $Id: Edit.tpl 3695 2007-11-26 22:01:04Z brian $ */ ?>
<?php TemplateUtility::printHeader('Candidates', array('modules/candidates/validator.js', 'modules/candidates/dynamicskillscertificates.js', 'js/sweetTitles.js', 'js/listEditor.js', 'js/doubleListEditor.js')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active); ?>
<div id="main">
    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">
        <table>
            <tr>
                <td width="3%">
                    <img src="images/candidate.gif" width="24" height="24" border="0" alt="Candidates" style="margin-top: 3px;" />&nbsp;
                </td>
                <td><h2>Candidates: Edit</h2></td>
            </tr>
        </table>

        <form name="editCandidateForm" id="editCandidateForm" action="<?php echo(CATSUtility::getIndexName()); ?>?m=candidates&amp;a=edit" method="post" onsubmit="return checkEditForm(document.editCandidateForm);" autocomplete="off">
            <input type="hidden" name="postback" id="postback" value="postback" />
            <input type="hidden" id="candidateID" name="candidateID" value="<?php $this->_($this->data['candidateID']); ?>" />

            <p class="note">Edit Candidate</p>
            <table class="editTable" width="925">
                <tr>
                    <Td class="tdVertical" width="450">
                        <table class="editTable" width="450">                           
                            <tr>
                                <td class="tdVertical">
                                    <label id="firstNameLabel" for="firstName">First Name:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="1" name="firstName" id="firstName" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['firstName']); ?>" />&nbsp;*
                                </td>                                
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="lastNameLabel" for="lastName">Last Name:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="3" name="lastName" id="lastName" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['lastName']); ?>" />&nbsp;*
                                </td>
                            </tr>   
                            <tr>
                                <td colspan="2" class="tdData">

                                </td>
                            </tr>
                        </table>
                    </Td>
                    <Td class="tdVertical"  width="450">
                        <table class="editTable" width="450">
                            <tr>
                                <td class="tdVertical">
                                    <label id="currentlocationLabel" for="currentlocation">Current Location:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="23" name="currentlocation" id="currentlocation" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['currentLocation']); ?>" />&nbsp;*
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="emailLabel" for="email1">E-Mail:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="6" name="email1" id="email1" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['email1']); ?>" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="phoneCellLabel" for="phoneCell">Cell Phone:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="9" name="phoneCell" id="phoneCell" class="inputbox" style="width: 150px;" value="<?php $this->_($this->data['phoneCell']); ?>" />
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="JobOrderLabel" for="prefferedlocation">JobOrder:</label>
                                </td>
                                <td class="tdData">
                                    <select id="JobOrderID" name="JobOrderID" class="inputbox" style="width: 150px;">
                                        <?php if ($this->allJobOrders !== false): ?>
                                        <?php foreach ($this->allJobOrders as $rowNumber => $contactsData): ?>
                                        <option value="<?php $this->_($contactsData['id']) ?>" <?php if (($this->_($this->candJobOrderID))==($this->_($contactsData['id']))) echo('selected'); ?>><?php $this->_($contactsData['title']) ?></option>
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
                            <input type="submit" class="button" name="submit" id="submit" value="Save" />
                        </div>
                    </td>
                </tr>
            </table>
            <table class="editTable" width="925">
                <tr>
                    <Td class="tdVertical" width="450">
                        <table class="editTable" width="450">                          
                            <tr>
                                <td class="tdVertical">
                                    <label id="sexlabel" for="sex">Sex:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="4" id="sex" name="sex" class="inputbox" style="width: 150px;">
                                        <option value="M" <?php if (strtolower($this->data['eeoGender']) == 'm') echo('selected'); ?>>Male</option>
                                        <option value="F" <?php if (strtolower($this->data['eeoGender']) == 'f') echo('selected'); ?>>Female</option>
                                        <option value="O" <?php if (strtolower($this->data['eeoGender']) == 'o') echo('selected'); ?>>Others</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="startDateLabel" for="startDate">DOB :</label>
                                </td>
                                <td class="tdData">
                                    <?php if (!empty($this->data['dob'])): ?>
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
                                    <input type="text" tabindex="24" name="prefferedlocation" id="prefferedlocation" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['prefferedLocation']); ?>" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="panlabel" for="pan">PAN:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="14" name="pan" id="pan" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['pan']); ?>" />
                                </td>
                            </tr>

                            <tr >
                                <td class="tdVertical">
                                    <label id="validpassportlabel" for="ValidPassport">Valid Passport:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="15" id="validpassport" name="validpassport" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="Yes" <?php if (strtolower($this->data['validpassport']) == 'yes') echo('selected'); ?>>Yes</option>
                                        <option value="No" <?php if (strtolower($this->data['validpassport']) == 'no') echo('selected'); ?>>No</option>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="skypeidlabel" for="skypeid">Skype ID:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="13" name="skypeid" id="skypeid" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['skypeid']); ?>" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="currentemployerlabel" for="currentemployer">Current Employer:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="30" name="currentemployer" id="currentemployer" class="inputbox" style="width: 150px;" value="<?php $this->_($this->data['currentemployer']); ?>" />
                                </td>
                            </tr>  
                        </table>
                    </Td>
                    <Td class="tdVertical"  width="450">
                        <table class="editTable" width="450">
                            <tr>
                                <td class="tdVertical">
                                    <label id="currentdesignationLabel" for="currentdesignation">Current Designation:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="25" name="currentdesignation" id="currentdesignation" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['currentdesignation']); ?>" />
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="currentctclabel" for="currentctc">Current CTC:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="31" name="currentCTC" id="currentCTC" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['currentCTC']); ?>" />
                                </td>
                            </tr>

                            <tr>
                                <td class="tdVertical">
                                    <label id="expectedctclabel" for="expectedctc">Expected CTC:</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="32" name="expectedCTC" id="expectedCTC" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['expectedCTC']); ?>" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical">
                                    <label id="durationLabel" for="duration">Total years of Exp.</label>
                                </td>
                                <td class="tdData">
                                    <input type="text" tabindex="32" name="expyearsstartID" id="expyearsstartID" class="inputbox" style="width: 150px" value="<?php $this->_($this->data['totalexp']); ?>" />
                                </td>                                  
                            </tr>
                            <tr >
                                <td class="tdVertical">
                                    <label id="noticeperiodlabel" for="noticeperiod">Notice Period:</label>
                                </td>
                                <td class="tdData">
                                    <select tabindex="27" id="noticeperiod" name="noticeperiod" class="inputbox" style="width: 150px;">
                                        <option value="-1">-Select from List-</option>
                                        <option value="Immediate" <?php if (strtolower($this->data['noticeperiod']) == 'immediate') echo('selected'); ?>>Immediate</option>
                                        <option value="7 days" <?php if (strtolower($this->data['noticeperiod']) == '7 days') echo('selected'); ?>>7 days</option>
                                        <option value="15 days" <?php if (strtolower($this->data['noticeperiod']) == '15 days') echo('selected'); ?>>15 days</option>
                                        <option value="30 days" <?php if (strtolower($this->data['noticeperiod']) == '30 days') echo('selected'); ?>>30 days</option>
                                        <option value="2 Month" <?php if (strtolower($this->data['noticeperiod']) == '2 month') echo('selected'); ?>>2 Month</option>
                                        <option value="3 Month" <?php if (strtolower($this->data['noticeperiod']) == '3 month') echo('selected'); ?>>3 Month</option>
                                        <option value="Greater than 3 Month" <?php if (strtolower($this->data['noticeperiod']) == 'greater than 3 month') echo('selected'); ?>>Greater than 3 Month</option>
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
                                        <option value="Better opportunity" <?php if (strtolower($this->data['reasonsforchange']) == 'better opportunity') echo('selected'); ?>>Better opportunity</option>
                                        <option value="Location constraint" <?php if (strtolower($this->data['reasonsforchange']) == 'location constraint') echo('selected'); ?>>Location constraint</option>
                                        <option value="On-site opportunity" <?php if (strtolower($this->data['reasonsforchange']) == 'on-site opportunity') echo('selected'); ?>>On-site opportunity</option>
                                        <option value="Salary" <?php if (strtolower($this->data['reasonsforchange']) == 'salary') echo('selected'); ?>>Salary</option>
                                        <option value="Others" <?php if (strtolower($this->data['reasonsforchange']) == 'others') echo('selected'); ?>>Others</option>
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
                                        <option value="Y" <?php if (strtolower($this->data['anyoffersinhand']) == 'y') echo('selected'); ?>>Yes</option>
                                        <option value="N" <?php if (strtolower($this->data['anyoffersinhand']) == 'n') echo('selected'); ?>>No</option>
                                    </select>
                                </td>
                            </tr>

                        </table>
                    </Td>

                </tr>
            </table>

            <br><p class="note">Candidate Skills </p>
            <table class="editTable" width="925">               
                <tr>
                    <td colspan="5" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="900" id="mytab1">
                                <?php if ($this->CandTechnicalSkills !== false): ?>
                                <?php foreach ($this->CandTechnicalSkills as $rowNumber => $contactsData): ?>
                                <tr>
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration" style="width: 100px;">Skill </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="mandatoryskillname" name="mandatoryskillname[]" 
                                               style="width: 150px;" value="<?php $this->_($contactsData['skillname']) ?>">
                                    </td> 
                                    <td width="15%" class="tdData">
                                        <label id="durationLabel" for="duration"># Projects Handled </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="projectshandled" name="projectshandled[]" 
                                               style="width: 100px;" value="<?php $this->_($contactsData['projectshandled']) ?>">
                                    </td> 
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration">Duration </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="duration" name="duration[]" 
                                               style="width: 50px;" value="<?php $this->_($contactsData['duration']) ?>">
                                    </td> 
                                    <td width="20%">
                                        <input  type="button" class="button" value="Add" onclick="mytab1addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab1')">
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                                <tr>
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration" style="width: 100px;">Skill </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="mandatoryskillname" name="mandatoryskillname[]" 
                                               style="width: 150px;" value="">
                                    </td> 
                                    <td width="15%" class="tdData">
                                        <label id="durationLabel" for="duration"># Projects Handled </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="projectshandled" name="projectshandled[]" 
                                               style="width: 100px;" value="">
                                    </td> 
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration">Duration </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="duration" name="duration[]" 
                                               style="width: 50px;" value="">
                                    </td> 
                                    <td width="20%">
                                        <input  type="button" class="button" value="Add" onclick="mytab1addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab1')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>

            <br><p class="note">Candidate Domain Knowledge </p>
            <table class="editTable" width="925">                   
                <tr>
                    <td colspan="5" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="900" id="mytab2">
                                <?php if ($this->CandDomainKnowledge !== false): ?>
                                <?php foreach ($this->CandDomainKnowledge as $rowNumber => $contactsData): ?>
                                <tr>
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration" style="width: 100px;">Domain </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="domainname" name="domainname[]" 
                                               style="width: 150px;" value="<?php $this->_($contactsData['skillname']) ?>">
                                    </td> 
                                    <td width="15%" class="tdData">
                                        <label id="durationLabel" for="duration">Client </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="clientname" name="clientname[]" 
                                               style="width: 100px;" value="<?php $this->_($contactsData['projectshandled']) ?>">
                                    </td> 
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration">Duration </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="domainduration" name="domainduration[]" 
                                               style="width: 50px;" value="<?php $this->_($contactsData['duration']) ?>">
                                    </td> 
                                    <td width="20%" >
                                        <input  type="button" class="button" value="Add" onclick="mytab2addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab2')">
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                                <tr>
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration" style="width: 100px;">Domain </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="domainname" name="domainname[]" 
                                               style="width: 150px;" value="">
                                    </td> 
                                    <td width="15%" class="tdData">
                                        <label id="durationLabel" for="duration">Client </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="clientname" name="clientname[]" 
                                               style="width: 100px;" value="">
                                    </td> 
                                    <td width="10%" class="tdData">
                                        <label id="durationLabel" for="duration">Duration </label>
                                    </td>
                                    <td width="15%" class="tdData">
                                        <input type="text" tabindex="35" class="inputbox" id="domainduration" name="domainduration[]" 
                                               style="width: 50px;" value="">
                                    </td> 
                                    <td width="20%" >
                                        <input  type="button" class="button" value="Add" onclick="mytab2addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab2')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>

            <br><p  class="note" style="margin-top: 5px;">Other</p>
            <table  class="editTable" width="925">
                <tr>
                    <td class="tdVertical">
                        <label id="othercertificationsLabel" for="othercertifications">Certifications</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="othercertifications" id="othercertifications" style="width: 400px;" value="<?php $this->_($this->data['certifications']); ?>" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="othercommunicationsLabel" for="othercommunications">Communication</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="othercommunications" id="othercommunications" style="width: 400px;" value="<?php $this->_($this->data['communication']); ?>" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="clientintegrationLabel" for="keySkills">Client Interation</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="clientintegration" id="clientintegration" style="width: 400px;" value="<?php $this->_($this->data['clientinteraction']); ?>" />
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
                        <label id="keySkillsLabel" for="keySkills">Key Skills:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" class="inputbox" name="keySkills" id="keySkills" style="width: 400px;" value="<?php $this->_($this->data['keySkills']); ?>" />
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="notesLabel" for="notes">Misc. Notes:</label>
                    </td>
                    <td class="tdData">
                        <textarea class="inputbox" name="notes" id="notes" rows="5" cols="40" style="width: 400px;"><?php $this->_($this->data['notes']); ?></textarea>
                    </td>
                </tr>
            </table>

            <input type="submit" class="button" name="submit" id="submit" value="Save" />&nbsp;
            <input type="reset"  class="button" name="reset"  id="reset"  value="Reset" onclick="resetFormForeign();" />&nbsp;
            <input type="button" class="button" name="back"   id="back"   value="Back to Details" onclick="javascript:goToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=candidates&amp;a=show&amp;candidateID=<?php echo($this->candidateID); ?>');" />
        </form>

        <script type="text/javascript">
            document.editCandidateForm.firstName.focus();
        </script>
    </div>
</div>
<div id="bottomShadow"></div>
<?php TemplateUtility::printFooter(); ?>
