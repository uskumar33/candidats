<?php /* $Id: AddActivityChangeStatusModal.tpl 3799 2007-12-04 17:54:36Z brian $ */ ?>
<?php if ($this->isJobOrdersMode): ?>
<?php TemplateUtility::printModalHeader('Job Orders', array('modules/candidates/activityvalidator.js', 'js/activity.js'), 'Job Orders: Log Activity'); ?>
<?php elseif ($this->onlyScheduleEvent): ?>
<?php TemplateUtility::printModalHeader('Candidates', array('modules/candidates/activityvalidator.js', 'js/activity.js'), 'Candidates: Schedule Event'); ?>
<?php else: ?>
<?php TemplateUtility::printModalHeader('Candidates', array('modules/candidates/activityvalidator.js', 'js/activity.js'), 'Candidates: Log Client Activity'); ?>
<?php endif; ?>

<?php if (!$this->isFinishedMode): ?>
<script type="text/javascript">
    < ?php if ($this - > isJobOrdersMode): ? >
            statusesArray = new Array(1);
    jobOrdersArray = new Array(1);
    statusesArrayString = new Array(1);
    jobOrdersArrayStringTitle = new Array(1);
    jobOrdersArrayStringCompany = new Array(1);
            statusesArray[0] = < ?php echo($this - > pipelineData['statusID']); ? > ;
            statusesArrayString[0] = '<?php echo($this->pipelineData['status']); ?>';
            jobOrdersArray[0] = < ?php echo($this - > pipelineData['jobOrderID']); ? > ;
            jobOrdersArrayStringTitle[0] = '<?php echo(str_replace("'", "\\'", $this->pipelineData['title'])); ?>';
            jobOrdersArrayStringCompany[0] = '<?php echo(str_replace("'", "\\'", $this->pipelineData['companyName'])); ?>';
            < ?php else: ? >
            < ?php $count = count($this - > pipelineRS); ? >
            statusesArray = new Array( < ?php echo($count); ? > );
            jobOrdersArray = new Array( < ?php echo($count); ? > );
            statusesArrayString = new Array( < ?php echo($count); ? > );
            jobOrdersArrayStringTitle = new Array( < ?php echo($count); ? > );
            jobOrdersArrayStringCompany = new Array( < ?php echo($count); ? > );
            < ?php for ($i = 0; $i < $count; ++$i): ? >
            statusesArray[ < ?php echo($i); ? > ] = < ?php echo($this - > pipelineRS[$i]['statusID']); ? > ;
            statusesArrayString[ < ?php echo($i); ? > ] = '<?php echo($this->pipelineRS[$i]['status']); ?>';
            jobOrdersArray[ < ?php echo($i); ? > ] = < ?php echo($this - > pipelineRS[$i]['jobOrderID']); ? > ;
            jobOrdersArrayStringTitle[ < ?php echo($i); ? > ] = '<?php echo(str_replace("'", "\\'", $this->pipelineRS[$i]['title'])); ?>';
            jobOrdersArrayStringCompany[ < ?php echo($i); ? > ] = '<?php echo(str_replace("'", "\\'", $this->pipelineRS[$i]['companyName'])); ?>';
            < ?php endfor; ? >
            < ?php endif; ? >
            statusTriggersEmailArray = new Array( < ?php echo(count($this - > statusRS)); ? > );
            < ?php foreach ($this - > statusRS as $rowNumber = > $statusData): ? >
            statusTriggersEmailArray[ < ?php echo($rowNumber); ? > ] = < ?php echo($statusData['triggersEmail']); ? > ;
            < ?php endforeach; ? ></script>
<script type="text/javascript">
            var ActivityTypes = ["Profile", "Interview", "HR"];

    var profileActivityType = ["Sourced", "Shortlisted", "Rejected", "Awaiting Feedback", "On Hold"];
    var interviewActivityType = ["Interview Scheduled", "Interview Rescheduled", "Interview Awaiting Feedback", "Interview On Hold", "Interview Shortlisted", "Interview Rejected"];
    var hrActivityType = ["Offered", "Rejected", "Declined", "Withdrawn", "Joined", "On Hold"];

    var interviewRejected = ["Technically NotFit", "Fake", "Salary", "Attitude", "Exprience", "Qualification", "Communication"];
    var interviewRescheduled = ["By Candidate", "By Company"];
    var interviewscheduled = ["Scheduled"];
    var interviewshortlisted = ["Scheduled for Next Round", "Finilized"];

    function statusIDChanged(cstatusID)
    {
        document.getElementById('lstinterviewrounds').style.visibility = "hidden";
        var selectAType = document.getElementById('activityTypeID');
        var ln = selectAType.length - 1;
        while (ln > 0)
        {
            selectAType.remove(1);  //Remove all but "Select State"
            ln--;
        }

        var ActivityType1 = document.getElementById('activitySubTypeID');
        var ln = ActivityType1.length - 1;
        while (ln > 0)
        {
            ActivityType1.remove(1);  //Remove all but "Select City"
            ln--;
        }

        var ActivityType0;

        switch (cstatusID)
        {
            case "Profile":
                ActivityType0 = profileActivityType
                break;
            case "Interview":
                document.getElementById('lstinterviewrounds').style.visibility = "visible";
                ActivityType0 = interviewActivityType
                break;
            case "HR":
                ActivityType0 = hrActivityType
                break;
            default:
        }

        for (i = 0; i < ActivityType0.length; i++)
        {
            var option = document.createElement('option');
            option.text = ActivityType0[i];
            option.value = ActivityType0[i];
            selectAType.add(option);
        }
    }

    function stateChanged(state)
    {
        document.getElementById("scheduleEvent").checked = false;
        document.getElementById("scheduleEventDiv").style.display = 'none';
        document.getElementById("scheduleEventchkboxDiv").style.display = 'none';
        document.getElementById("scheduleEventlabelDiv").style.display = 'none';

        var ActivityType2 = document.getElementById('activitySubTypeID');
        var ln = ActivityType2.length - 1;
        while (ln > 0)
        {
            ActivityType2.remove(1);  //Remove all but "Select City"
            ln--;
        }

        //document.getElementById("activitySubTypeID").style.display = "block";
        var cityArray;

        switch (state)
        {
            case "Interview Rejected":
                cityArray = interviewRejected
                break;
            case "Interview Rescheduled":
                cityArray = interviewRescheduled
                break;
            case "Interview Scheduled":
                document.getElementById("scheduleEvent").checked = true;
                document.getElementById("scheduleEventDiv").style.display = 'block';
                document.getElementById("scheduleEventchkboxDiv").style.display = 'block';
                document.getElementById("scheduleEventlabelDiv").style.display = 'block';
                cityArray = interviewscheduled
                break;
            case "Interview Shortlisted":
                cityArray = interviewshortlisted
                break;
            default:
                //document.getElementById("activitySubTypeID").style.display = "none";
                //break;
        }

        for (i = 0; i < cityArray.length; i++)
        {
            var option = document.createElement('option');
            option.text = cityArray[i];
            option.value = cityArray[i];
            ActivityType2.add(option);
        }
    }

    function cityChanged(city)
    {
        /*switch(city)
         {
         case "test":
         alert("test text") 
         break;                
         default:
         } */
    }
</script>
<form name="changePipelineStatusForm" id="changePipelineStatusForm" action="<?php echo(CATSUtility::getIndexName()); ?>?m=<?php if ($this->isJobOrdersMode): ?>joborders<?php else: ?>candidates<?php endif; ?>&amp;a=addActivityChangeClientStatus<?php if ($this->onlyScheduleEvent): ?>&amp;onlyScheduleEvent=true<?php endif; ?>" method="post" onsubmit="return checkActivityForm(document.changePipelineStatusForm);" autocomplete="off">
    <input type="hidden" name="postback" id="postback" value="postback" />
    <input type="hidden" id="candidateID" name="candidateID" value="<?php echo($this->candidateID); ?>" />
    <?php if ($this->isJobOrdersMode): ?>
    <input type="hidden" id="regardingID" name="regardingID" value="<?php echo($this->selectedJobOrderID); ?>" />
    <?php endif; ?>

    <table class="editTable" width="560">
        <tr id="visibleTR" <?php if ($this->onlyScheduleEvent): ?>style="display:none;"<?php endif; ?>>
            <td class="tdVertical">
                <label id="regardingIDLabel" for="regardingID">Regarding:</label>
            </td>
            <td class="tdData">
                <?php if ($this->isJobOrdersMode): ?>
                <span><?php $this->_($this->pipelineData['title']); ?></span>
                <?php else: ?>
                <select id="regardingID" name="regardingID" class="inputbox" style="width: 150px;" onchange="AS_onRegardingChange(statusesArray, jobOrdersArray, 'regardingID', 'statusID', 'statusTR', 'sendEmailCheckTR', 'triggerEmail', 'triggerEmailSpan', 'changeStatus', 'changeStatusSpanA', 'changeStatusSpanB');">
                    <option value="-1">General</option>

                    <?php foreach ($this->pipelineRS as $rowNumber => $pipelinesData): ?>
                    <?php if ($this->selectedJobOrderID == $pipelinesData['jobOrderID']): ?>
                    <option selected="selected" value="<?php $this->_($pipelinesData['jobOrderID']) ?>"><?php $this->_($pipelinesData['title']) ?></option>
                    <?php else: ?>
                    <option value="<?php $this->_($pipelinesData['jobOrderID']) ?>"><?php $this->_($pipelinesData['title']) ?> (<?php $this->_($pipelinesData['companyName']) ?>)</option>
                    <?php endif; ?>
                    <?php endforeach; ?>
                </select>
                <?php endif; ?>
            </td>           
        </tr>

        <tr id="statusTR" >
            <td class="tdVertical">
                <label id="statusIDLabel" for="statusID">Client Activity:</label>
            </td>
            <td class="tdData">
                <div style="display:none;">
                    <input type="checkbox" name="changeStatus" id="changeStatus" style="margin-left: 0px" onclick="AS_onChangeStatusChange('changeStatus', 'statusID', 'changeStatusSpanB');"<?php if ($this->selectedJobOrderID == -1 || $this->onlyScheduleEvent): ?> disabled<?php endif; ?> />
                           <span id="changeStatusSpanA"<?php if ($this->selectedJobOrderID == -1): ?> style="color: #aaaaaa;"<?php endif;?>>Change Status</span><br />
                </div>
                <div id="changeStatusDiv" style="margin-top: 4px;">
                    <select id="statusID" name="statusID" class="inputbox" style="width: 150px;" onchange='statusIDChanged(this.value);' >
                        <option selected="selected" value="-1">(Select Client Activity)</option>
                        <option value="Profile">Profile</option>
                        <option value="Interview">Interview</option>
                        <option value="HR">HR</option>
                    </select>
                    <span id="changeStatusSpanB" style="color: #aaaaaa;">&nbsp;*</span>
                    <select id="lstinterviewrounds" name="lstinterviewrounds" class="inputbox" style="width: 100px; margin-bottom: 4px; visibility:hidden;">
                        <option value='Round-1'>Round-1</option>
                        <option value='Round-2'>Round-2</option>
                        <option value='Round-3'>Round-3</option>
                        <option value='Round-4'>Round-4</option>
                        <option value='Round-5'>Round-5</option>
                    </select>
                    <span id="triggerEmailSpan" style="display: none;"><input type="checkbox" name="triggerEmail" id="triggerEmail" onclick="AS_onSendEmailChange('triggerEmail', 'sendEmailCheckTR', 'visibleTR');" />Send E-Mail Notification to Candidate</span>
                </div>
            </td>
        </tr>

        <tr id="sendEmailCheckTR" style="display: none;">
            <td class="tdVertical">
                <label id="triggerEmailLabel" for="triggerEmail">E-Mail:</label>
            </td>
            <td class="tdData">
                Custom Message<br />
                <input type="hidden" id="origionalCustomMessage" value="<?php $this->_($this->statusChangeTemplate); ?>" />
                <input type="hidden" id="emailIsDisabled" value="<?php echo($this->emailDisabled); ?>" />
                <textarea style="height:135px; width:375px;" name="customMessage" id="customMessage" cols="50" class="inputbox"></textarea>
            </td>
        </tr>
        <tr id="addActivityTR" <?php if ($this->onlyScheduleEvent): ?>style="display:none;"<?php endif; ?>>
            <td class="tdVertical">
                <label id="addActivityLabel" for="addActivity">Activity Type:</label>
            </td>
            <td class="tdData">
                <div style="display:none;">
                    <input type="checkbox" name="addActivity" id="addActivity" style="margin-left: 0px;"<?php if (!$this->onlyScheduleEvent): ?> checked="checked"<?php endif; ?> onclick="AS_onAddActivityChange('addActivity', 'activityTypeID', 'activityNote', 'addActivitySpanA', 'addActivitySpanB');" />Log an Activity<br />
                </div>
                <div id="activityNoteDiv" style="margin-top: 4px;">
                    <select id="activityTypeID" name="activityTypeID" onchange='stateChanged(this.value);' class="inputbox" style="width: 150px; margin-bottom: 4px;">
                        <option value=''>Select Activity Type</option>
                    </select>  
                    <div id="scheduleEventchkboxDiv" style="margin-top: 4px; display: none;">
                        <input type="checkbox" name="scheduleEvent" id="scheduleEvent" style="margin-left: 0px; <?php if ($this->onlyScheduleEvent): ?>display:none;<?php endif; ?>" onclick="AS_onScheduleEventChange('scheduleEvent', 'scheduleEventDiv');"<?php if ($this->onlyScheduleEvent): ?> checked="checked"<?php endif; ?> /><?php if (!$this->onlyScheduleEvent): ?>Schedule Event<?php endif; ?>
                    </div>
                </div>
            </td>
        </tr>
        <tr id="addActivitysubTR" <?php if ($this->onlyScheduleEvent): ?>style="display:none;"<?php endif; ?>>
            <td class="tdVertical">
                <label id="addActivitySubLabel" for="addActivity">Activity Sub Type:</label>
            </td>
            <td class="tdData">
                <div id="activitySubNoteDiv" style="margin-top: 4px;">
                    <select id="activitySubTypeID" name="activitySubTypeID" onchange='cityChanged(this.value);' class="inputbox" style="width: 150px; margin-bottom: 4px;">
                        <option value=''>Select Activity SubType</option>
                    </select>
                </div>
            </td>
        </tr>
        <tr id="addActivityNotesTR" >
            <td class="tdVertical">
                <label id="addActivityLabel" for="addActivity">Activity Notes:</label>
            </td>
            <td class="tdData">
                <textarea name="activityNote" id="activityNote" cols="50" style="margin-bottom: 4px;" class="inputbox"></textarea>
                </div>
            </td>
        </tr>

        <tr id="addActivityNotesTR" >
            <td class="tdVertical">
                <div id="scheduleEventlabelDiv" style="margin-top: 4px; display: none;">
                    <label id="scheduleEventLabel" for="scheduleEvent">Schedule Event:</label>
                </div>
            </td>
            <td class="tdData">

                <div id="scheduleEventDiv" <?php if (!$this->onlyScheduleEvent): ?>style="display:none;"<?php endif; ?>>
                     <table style="border: none; margin: 0px; padding: 0px;">
                        <tr>
                            <td valign="top">
                                <div style="margin-bottom: 4px;">
                                    <select id="eventTypeID" name="eventTypeID" class="inputbox" style="width: 150px;">
                                        <?php foreach ($this->calendarEventTypes as $eventType): ?>
                                        <option <?php if ($eventType['typeID'] == CALENDAR_EVENT_INTERVIEW): ?>selected="selected" <?php endif; ?>value="<?php echo($eventType['typeID']); ?>"><?php $this->_($eventType['description']); ?></option>
                                        <?php endforeach; ?>
                                    </select>
                                </div>

                                <div style="margin-bottom: 4px;">
                                    <script type="text/javascript">DateInput('dateAdd', true, 'MM-DD-YY', '', -1);</script>
                                </div>

                                <div style="margin-bottom: 4px;">
                                    <input type="radio" name="allDay" id="allDay0" value="0" style="margin-left: 0px" checked="checked" onchange="AS_onEventAllDayChange('allDay1');" />
                                    <select id="hour" name="hour" class="inputbox" style="width: 40px;">
                                        <?php for ($i = 1; $i <= 12; ++$i): ?>
                                        <option value="<?php echo($i); ?>"><?php echo(sprintf('%02d', $i)); ?></option>
                                        <?php endfor; ?>
                                    </select>&nbsp;
                                    <select id="minute" name="minute" class="inputbox" style="width: 40px;">
                                        <?php for ($i = 0; $i <= 45; $i = $i + 15): ?>
                                        <option value="<?php echo(sprintf('%02d', $i)); ?>">
                                            <?php echo(sprintf('%02d', $i)); ?>
                                        </option>
                                        <?php endfor; ?>
                                    </select>&nbsp;
                                    <select id="meridiem" name="meridiem" class="inputbox" style="width: 45px;">
                                        <option value="AM">AM</option>
                                        <option value="PM">PM</option>
                                    </select>
                                </div>

                                <div style="margin-bottom: 4px;">
                                    <input type="radio" name="allDay" id="allDay1" value="1" style="margin-left: 0px" onchange="AS_onEventAllDayChange('allDay1');" />All Day / No Specific Time<br />
                                </div>

                                <div style="margin-bottom: 4px;">
                                    <input type="checkBox" name="publicEntry" id="publicEntry" style="margin-left: 0px" />Public Entry
                                </div>
                            </td>

                            <td valign="top">
                                <div style="margin-bottom: 4px;">
                                    <label id="titleLabel" for="title">Title&nbsp;*</label><br />
                                    <input type="text" class="inputbox" name="title" id="title" style="width: 180px;" />
                                </div>

                                <div style="margin-bottom: 4px;">
                                    <label id="durationLabel" for="duration">Length:</label>
                                    <br />
                                    <select id="duration" name="duration" class="inputbox" style="width: 180px;">
                                        <option value="15">15 minutes</option>
                                        <option value="30">30 minutes</option>
                                        <option value="45">45 minutes</option>
                                        <option value="60" selected="selected">1 hour</option>
                                        <option value="90">1.5 hours</option>
                                        <option value="120">2 hours</option>
                                        <option value="180">3 hours</option>
                                        <option value="240">4 hours</option>
                                        <option value="300">More than 4 hours</option>
                                    </select>
                                </div>

                                <div style="margin-bottom: 4px;">
                                    <label id="descriptionLabel" for="description">Description</label><br />
                                    <textarea name="description" id="description" cols="20" class="inputbox" style="width: 180px; height:60px;"></textarea>
                                </div>

                                <div <?php if (!$this->allowEventReminders): ?>style="display:none;"<?php endif; ?>>
                                    <input type="checkbox" name="reminderToggle" onclick="if (this.checked)
                                                document.getElementById('reminderArea').style.display = '';
                                            else
                                                document.getElementById('reminderArea').style.display = '';">&nbsp;<label>Set Reminder</label><br />
                                </div>

                                <div style="display:none;" id="reminderArea">
                                    <div>
                                        <label>E-Mail To:</label><br />
                                        <input type="text" id="sendEmail" name="sendEmail" class="inputbox" style="width: 150px" value="<?php $this->_($this->userEmail); ?>" />
                                    </div>
                                    <div>
                                        <label>Time:</label><br />
                                        <select id="reminderTime" name="reminderTime" style="width: 150px">
                                            <option value="15">15 min early</option>
                                            <option value="30">30 min early</option>
                                            <option value="45">45 min early</option>
                                            <option value="60">1 hour early</option>
                                            <option value="120">2 hours early</option>
                                            <option value="1440">1 day early</option>
                                        </select>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>



    </table>
    <input type="submit" class="button" name="submit" id="submit" value="Save" />&nbsp;
    <?php if ($this->isJobOrdersMode): ?>
    <input type="button" class="button" name="close" value="Cancel" onclick="parentGoToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=show&amp;jobOrderID=<?php echo($this->selectedJobOrderID); ?>');" />
    <?php else: ?>
    <input type="button" class="button" name="close" value="Cancel" onclick="parentGoToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=candidates&amp;a=show&amp;candidateID=<?php echo($this->candidateID); ?>');" />
    <?php endif; ?>
</form>

<script type="text/javascript">
    document.changePipelineStatusForm.activityNote.focus();</script>

<?php else: ?>
<?php if (!$this->changesMade): ?>
<p>No changes have been made.</p>
<?php else: ?>
<?php if (!$this->onlyScheduleEvent): ?>
<?php //FIXME: E-mail stuff. ?>
<?php if ($this->statusChanged): ?>
<p>The candidate's status has been changed from <span class="bold"><?php $this->_($this->oldStatusDescription); ?></span> to <span class="bold"><?php $this->_($this->newStatusDescription); ?></span>.</p>
<?php else: ?>
<p>The candidate's status has not been changed.</p>
<?php endif; ?>

<?php if ($this->activityAdded): ?>
<?php if (!empty($this->activityDescription)): ?>
<p>An activity entry of type <span class="bold"><?php $this->_($this->activityType); ?></span> has been added with the following note: &quot;<?php echo($this->activityDescription); ?>&quot;.</p>
<?php else: ?>
<p>An activity entry of type <span class="bold"><?php $this->_($this->activityType); ?></span> has been added with no notes.</p>
<?php endif; ?>
<?php else: ?>
<p>No activity entries have been added.</p>
<?php endif; ?>
<?php endif; ?>
<?php endif; ?>

<?php echo($this->eventHTML); ?>

<?php echo($this->notificationHTML); ?>

<form>
    <?php if ($this->isJobOrdersMode): ?>
    <input type="button" name="close" class="button" value="Close" onclick="parentGoToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=show&amp;jobOrderID=<?php echo($this->regardingID); ?>');" />
    <?php else: ?>
    <input type="button" name="close" class="button" value="Close" onclick="parentGoToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=candidates&amp;a=show&amp;candidateID=<?php echo($this->candidateID); ?>');" />
    <?php endif; ?>
</form>
<?php endif; ?>

</body>
</html>
