
#ifndef _optimizedFunctions_h
#define _optimizedFunctions_h

#include "globals.h"
#include "optimizedGB.h"

char **getArrayOrderedTracks(void);
 char **getDatabaseNames(void);
 char *getEntrypointName(void);
 char **getFeatureQueries(void);
 char *getFeatureQuery(int currentDatabase);
 char **getInStatements(void);
 char *getMyDatabaseToUse(void);
 char *getMySpecialTrack(void);
 char *getSingleInStatement(int databaseId);
 char *getTrackNameFromTypeId(int database, int typeId);
 double getUniversalScale(void);
 FILE *getMapPointerFile(void);
 void myDecodeQuantum(unsigned char *dest, const char *src);
 size_t myBase64_decode(const char *src, char *dest);
 size_t myBase64_encode(const char *inp, size_t insize, char **outptr);
 void processLinksGroupAware(int initialHeight, int visibility, int theHeight, int mid, float thick, int maxLevel  ,myGroup *initialGroup);
 void processLinksGroupUnaware(int initialHeight, int visibility, int theHeight, int mid, float thick, int maxLevel  ,myGroup *initialGroup);
 int printTextSizeFromFid(gdImagePtr im, gdFontPtr font, int uploadId, long fid, char type, long limit, int sizeToCopy, int x , int y  , int colorToUse);
 GHashTable *getFeatureTypeHash(void);
 GHashTable *getGclassHash(void);
 GHashTable *getGroupHash(void);
 GHashTable *getGroupId2groupStartHash(void);
 GHashTable *getGroupIds2GroupHash(void);
 GHashTable *getGroups2TrackHash(void);
 GHashTable *getOrderHash(void);
 GHashTable *getTagsHash(void);
 GHashTable *getTrackName2TrackHash(void);
 GHashTable *getTypeId2FeatureTypeHash(void);
 GHashTable *getTypeIdHash(void);
 int addGroup2GroupIds2GroupHash(myGroup *currentGroup, int groupId);
 int addGroup2TrackHash(int database, int typeId, int groupId);
 int addTypeIdHash(char *typeIdStr, int databaseId);
 int closeLocalConnection(int type);
 int getImageMapHeight(char *theTrackName);
 int *getArrayUploadIds(void);
 int getCanvasWidth(void);
 int getDisplayEmptyTracks(void);
 int getEntrypointId(int databaseId);
 int getFinalGroupId(void);
 int getGroupCounter(void);
 int getInitialGroupId(void);
 int getSpaceBetweenTracks(void);
 void setSpaceBetweenTracks(int myWidth);
 char *returnMyVisibilityClassName(char *track_name);
 int getLabelWidth(void);
 int getMaxOrder(void);
 int getMyDebug(void);
 int getNumberDatabases(void);
 int getNumberOfAllFeatures(void);
 int getNumberOfTracks(void);
 int getStartFirstTrack(void);
 int getTotalHeight(void);
 int getTotalWidth(void);
 int getTrackWidth(void);
 int resetLocalConnection(char *theDatabaseToUse);
 int returnGroupId(char *gClass, char *groupName, char *trackName);
 int setEPProperties(char *entrypointName, int databaseId);
 int startLocalConnection(int type);
 long getGroupStartForGroupId(int groupId);
 long getMyUserId(void);
 int insertGroupStart(int groupId, long groupStart);
 long long getEndPosition(void);
 long long getEntrypointLength(int databaseId);
 long long getLengthOfSegment(void);
 myGroup *returnGroupFromGroupId(int groupId);
 MYSQL *returnLocalConnection(int type);
 MYSQL returnMyMYSQL(int type);
 myTrack *getEmptyTrackList(void);
 myTrack *getTrackList(void);
 myTrack *returnTrackFromTrackName(char *trackName);
 char *getGifFileName(void);
 char *getIMAPFileName(void);
 void destroyGifName(void);
 void destroyIMAPName(void);
 void setGifFileName(char *theGifName);
 void setIMAPFileName(char *theIMAPName);
 time_t getGlobalStartTime(void);
 void fillGclassHash(void);
 void fillAttNameIdForTemplateDb(void);
 void fillAttValueIdForTemplateDb(void);
 void fillAttNameIdForUserDb(void);
 void fillAttValueIdForUserDb(void);
 void setAttNameIdHashTemplate(void);
 void setAttValueIdHashTemplate(void);
 void setAttNameIdHashUser(void);
 void setAttValueIdHashUser(void);
 GHashTable *getAttNameIdHashTemplate(void);
 GHashTable *getAttValueIdHashTemplate(void);
 GHashTable *getAttNameIdHashUser(void);
 GHashTable *getAttValueIdHashUser(void);
 int fillOrderHash(void);
 void fillTrackListOfGroups(void);
 void increaseUniversalCounter(void);
 void insertTrackInTrackName2TrackHash(myTrack *myLocalTrack);
 void setArrayOrderedTracks(char **myTracks);
 void destroyArrayOrderedTracks(void);
 int getNumberOfItemsInArrayOrderedTracks(void);
 void setNumberOfItemsInArrayOrderedTracks(int items);
 void setArrayUploadIds(long refSeqId);
 long *getArrayRecordsInfidText(void);
 void setArrayRecordsInfidText(void);
 void setCanvasWidth(int myWidth);
 void setDatabaseNames(long refSeqId);
 void setDisplayEmptyTracks(int NoYes);
 void setEmptyTrackList(myTrack *firstTrack);
 void setEndPosition(long long end);
 void setEntryPointNameProperties(char *myEntrypointName);
 void setFeatureHash(void);
 void setFeatureQueries(void);
 void setFeatureTypeHash(void);
 void setFinalGroupId(int myFinalId);
 void setGclassHash(void);
 void setGlobalStartTime(time_t theTime);
 void setGroupCounter(int myCounter);
 void setGroupHash(void);
 void setGroupId2groupStartHash(void);
 void setGroupIds2GroupHash(void);
 void setgroups2TrackHash(void);
 void setInitialGroupId(int myInitialId);
 void setInStatements(void);
 void setLabelWidth(int width);
 void setLengthOfSegment(long long length);
 void setMapPointerFile(FILE *thisPointer);
 void setMaxOrder(int maxNumber);
 void setMyDatabaseToUse(char *theDatabaseName);
 void setMyDebug(int yesno);
 void setMyUserId(long theUserId);
 void setNumberDatabases(int myNumber);
 void setNumberOfAllFeatures(int myNumber);
 void setNumberOfTracks(int myNumberOfTracks);
 void setOrderHash(void);
 void setStartFirstTrack(int start);
 void setTagsHash(void);
 void setTotalHeight(int myHeight);
 void calculateImageHeight(void);
 void setTotalWidth(int width);
 void setTrackList(myTrack *firstTrack);
 void setTrackName2TrackHash(void);
 void setTrackWidth(int width);
 void setTypeId2FeatureTypeHash(void);
 void setTypeIdHash(void);
 void setUniversalScale(double myScale);
 char *createInStatement(int databaseToUse);
 char *generateFeatureQuery(int currentDatabase);
 char *getDatabaseFromId(int databaseNumber);
 char *getFeatureTypeColor(char *featureType);
 char *getFeatureTypeStyle(char *featureType);
 char *getLinkNames(char *databaseFtypeId);
 char *getRawLink(char *featureType);
 char *getTheColorUsed(char *databaseFtypeId);
 char *getTheStyleUsed(char *databaseFtypeId);
 char **processLinkString(char *myString, int *numberOfStrings);
 char *returnFractionOfBin(long valueRequested, long long tier);
 char *returnStripedName(char *geneName);
 char *returnType(char *trackName, int whichToReturn);
 char *URLUTF8Encoder(char *data);
 float generateMaxScoreFromTrackName(char *trackName, int localRange);
 float generateMinScoreFromTrackName(char *trackName, int localRange);
 float requestMaxScore(int ftypeId, int counter, int localRange);
 float requestMinScore(int ftypeId, int counter, int localRange);
 gdImagePtr initializeCanvasGD(char *Name);
 groupStartingPoint *createListOfGroups(int lengthOfList);
 int compareToSpecialTrack(char *realNameTrack);
 int drawRefSeqGD(gdImagePtr im, struct rgbColor colorRefSeq, char *Name);
 int drawRulerGD(gdImagePtr im, char *legend, int from, int to);
 int extractDatabaseId(char *databaseFeature);
 int fillGroupLevel(myTrack *myLocalTrack);
 int getDatabasePositionFromUploadId(int uploadId);
 int getMyTrackHeight(char *theTrackName);
 int initializeProcess(long refSeqId, char *myEntrypointName, long long from, long long to);
 int myCmpSP(const void *first, const void *second);
 int requestFtypeIdFromDB(char *fmethod, char *fsource, int counter);
 int returnCase(char *myString);
 int returnCompactWidth();
 int returnTagLength(char *myString);
 int verifyDatabases(void);
 long *createListOfGroupStarts(int lengthOfList);
 long long getMetaInfo(int currentDatabase, int isMax);
 long long getTickSpan(long long totalLength, int maxNumTicks);
 myAnnotations *makeAnnotation(void);
 myGroup *makeGroup(char *groupClass, char *groupName, int groupId, char *allGroupIds);
 myTrack *createNewHead(void);
 myTrack *makeTrack(void);
 size_t commifyInt(char *strBuff, size_t size, long long argnum);
 char *getstring(int size);
 int generateNames(char *baseName, char *fileName);
 int validateForm(int refSeqId);
 int verifyDatabaseId(char *query);
 rgbColorStruct *fromHexaToRGB(char *hexavalue);
 struct rgbColor *fromrgbMyStruct2rgbColor(rgbColorStruct *myColor);
 struct rgbColor *transformColor(char *colorUsed);
 void accumulateTime(time_t myStartTime, time_t myEndTime);
 void cleanListOfGroups(int *localListOfGroups, int maxSize);
 void destroyDoublePointer(char **ptr, int max_hits);
 void destroyEmptyTrackList(void);
 void destroyHashTable(GHashTable *genericHashTable);
 void drawDispatcherGD(gdImagePtr im, myGroup *currentGroup, int visibility, int *multicolor, int allocatedColor, int initialHeight, int theHeight, char *functionName, float maxScore, float minScore, int allocatedUpperColor, int allocatedLowerColor, myTrack *localTrack);
 void drawRulerTextGD(gdImagePtr im, int xOff, int yOff, int width, long long startNum, long long range, int bumpX, int bumpY, int color);
 void drawTracksGD(gdImagePtr im, struct rgbColor colorLeftPanel);
 void eliminateEmptyTracks(void);
 void fillTracks(void);
 void fillTypeIdHash(void);
 void finalizeProcess(int newSchema);
 void fix_coords(long long *start, long long *stop, long long size);
 void generateTracks(void);
 void mainDraw(gdImagePtr im, int trackStart, myTrack *localTrack);
 void makeImageMap();
 void NgroupNeg_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void Nnegative_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void Nbarbed_wireGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, int drawGroupLine);
 void Nbes_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void Ncdna_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void Nchromosome_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void newClickThrough(int trackStart, myTrack *localTrack);
 void Ngene_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void NlargeScore_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, float minScore, int allocatedUpperColor, int allocatedLowerColor, myTrack *localTrack);
 void Nsimple_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void NsingleFos_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 void Ntag_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
void NgradientScore_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, int maxFactor);
void NDifferentialgradientScore_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, int incrementalGradient);
 void printDatabases(void);
 void resetMyTiming(time_t myStartTime);
 void timeItNow(char *message)		;
 char *transformLinkTemplate(myAnnotations *currentAnnotation);
 int getPrintXML(void);
 void setPrintXML(int yesNo);
 int returnMyVisibilityValue(char *track_name);
 void createMyVisibility(char *theTracks);
 void destroyMyVisibility(void) ;
 void generateVisDataFromXml(char *xmlFileName);
 void setMyVisibility(TVIS *myVisibilityUsed);
 int getGroupOrderUsingXml(void);
 int createArrayOrderedTracks(void);
 void setGroupOrderUsingXml(int yesNo);
 void setFilterImageMapFileName(char *filterName);
 char *getFilterImageMapFileName(void);
 void setRawFileName(char *theRawName);
 void setMapFileName(char *theIMAPName);
 void setRawPointerFile(FILE *thisPointer);
 FILE *getRawPointerFile(void);
 void setRawPointerFile(FILE *thisPointer);
 FILE *getRawPointerFile(void);
 char *getRawFileName(void);
 void setRawFileName(char *theRawName);
 char *getMapFileName(void);
 extern ssize_t pread64 (int __fd, void *__buf, size_t __nbytes, __off64_t __offset) __THROW;
 extern ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset);
 char *getSequenceFragment(char *fastafile, long long begin_index, long long end_index);
 void setGenomicFileName(void);
 char *getGenomicFileName(void);
 int getGroupAwareness(char *functionName);
 int returnTransformedValue(unsigned long theValue);
 char *getTextFromFid(int uploadId, long fid, int ftypeid, char type, long limit);
 int getTextSizeFromFid(int uploadId, long fid, char type, long limit);
 int getVisibilityFromTypeId(int database, int typeId);
 char *extractPropertyName(char *line);
 char *extractPropertyValue(char *line);
 void destroy_double_pointer(char **ptr, int max_hits);
 void destroyProperties(void) ;
 int loadPreferencesFile(char *fileName);
 int returnKeyValue(char *preferenceName);
 char *getDbHost(void);
 void setDbHost(char *databaseName);
 void setGenboreeUserName(char *userName);
 void setGenboreePassword(char *password);
 void setGenboreeDbNameUserNameAndPassword(void);
 char *getGenboreeUserName(void);
 char *getGenboreePassword(void);
 int findRegExSize(const char *myString);
 char *returnField(const char *myString);
 char *returnRegex(const char *myString);
 char *returnRegExPattern(char *pattern, const char *subject, pcre **previousRe);
 char *returnResultExtractingField(myAnnotations *currentAnnotation, char *pattern, char *fieldName);
 char *fieldValue(myAnnotations *currentAnnotation, char *substring);
 char *returnNextRegex(const char *myString);
 char *returnPartRegEx(const char *myString, int fieldRegexAll);
 void pie_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, int maxFactor);
 char *getStyleNameFromStyleId(char *databaseName, int styleId);
 int getftypeidFromFmethodFsource(char *databaseName, char *fmethod, char *fsource);
 int getStyleIdFromFtypeidUserid(char *databaseName, int ftypeid, long userid);
 char *getNameSemicolonSeparatedWord(char *semicolonSeparatedWord, int getLast);
 char *getTheStyleUsedCheckingAllDatabases(char *fmethodFsource);
 char *getFeatureTypeColorCheckingAllDatabases(char *fmethodFsource);
 int getColorIdFromFtypeidUserid(char *databaseName, int ftypeid, long userid);
 char *getColorCodeFromColorId(char *databaseName, int colorId);
 GHashTable *getLinkInfoHash(void);
 void setLinkInfoHash(void);
 char *getMD5LinksCheckingAllDatabases(char *fmethodFsource);
 void setAllFmethodFsource(void);
 GHashTable *getAllFmethodFsource(void);
 char *getArrayOfTypeIds(char *databaseName);
 void printAllArrays(void);
 void setAllSortFmethodFsource(void);
 void fillSortHashTable(GHashTable *tempSortHash, char *databaseName, long currentUserId, char *arrayOfTypeIds, int currentValue);
 void fillSortHashTableWithFtypeIds(GHashTable *tempSortHash, char *databaseName, int databaseId, long currentUserId, char *arrayOfTypeIds, int currentValue);
 GHashTable *getAllSortedFmethodFsource(void);
 int *generateIntArrayFromStringAndSeparator(const char *list, const char *selectedSeparator);
 int countNumberSeparatorsInWord(const char *specialWord, const char *selectedSeparator);
 char *getSubstringsFromWord(const char *specialWord, int substring, const char *selectedSeparator);
 int getgidFromGclassNameDatabaseName(char *databaseName, char *gclassName);
 char *getgidFromGclassName(char *gclassName);
 char *getClassesArrayFmethodFsourceMainDatabase(char *fmethodFsource);
 int returnGClass(void);
 GHashTable *getFeatureToGclassHash(void);
 void setFeatureToGclassHash(void);
 char *returnFirstClassName(char *trackName);
 char *returnAllClassNames(char *trackName);
 long getGenomicOffset(void);
 int *fetchArrayOfFtypeIds(int databaseId);
 void setTypeIdsStatementByDatabaseId(void);
 char **getTypeIdsStatementByDatabaseId(void);
 void drawGroupContextLines(gdImagePtr im, myGroup *currentGroup, int visibility, int x1, int y1, int x2, int y2, int selectedColor);
 void setUseMargins(int yesNo);
 int getUseMargins(void);
 char *dec2hex(int dec);
 int hex2dec(const char *hex);
 void setPNG(int yesno);
 int getPNG(void);
 int isDatabaseNewFormat(int uploadId);
 char *getValueFromAttValueId(int databaseIndex, int attValueId, long limit);
 int getAttNameIdFromName(int databaseIndex, char* name);
 int getFirstAttValueIdForAttId(int databaseIndex, long fid, int ftypeid, int attNameId);
 char *getVPValueFromFid(int uploadId, long fid, int ftypeid, char* name, long limit);
 char *extractInfoFromValuePairValue(char *pattern, char *valuePairValue);
 char *extractNameFromField(char *substring);
 char *extractPatternFromField(char *substring);
 char *cleanUpVP(const char *myString);
 int vpHasRegEx(const char *myString);
 void  insort (register char **array, register int len);
 void  partial_quickersort (register char **array, register int lower, register int upper);
 char **sedgesort(char **array, int len);
 char **returnSortedListOfRecordsFromDBIDFtypeId(char **initialArray, int lengthArray);
 long getRefSeqId(void);
 void setRefSeqId(long myRefSeqId);
 int fetchGenboreeGroup(long refSeqId);
 void setGenboreeGroupId(int myGroupId);
 int getGenboreeGroupId(void);
 void setDatabase2HostHash(void);
 void setDatabase2ConnectionHash(void);
 GHashTable *getDatabase2HostHash(void);
 GHashTable *getDatabase2ConnectionHash(void);
 void setPreserveDefaultTrackOrder(int yesno);
 int getPreserveDefaultTrackOrder(void);
 int findNextAvailableLocation(int *temporaryOrder, int startPosition, int endPosition);
 int *createOrderArrayFromHash(GHashTable *tempSortHash);
 int *fillUpOrderArrayFromHash(int *temporaryOrder, GHashTable *tempSortHash);
 GHashTable *createHashWithNewOrder(int *temporaryOrder, GHashTable *allSortedHash, int maxValue);
 GHashTable *deleteHashTable(GHashTable *allSortedHash);
 int fetchMaxSortKeyFromDb(char *databaseName, long currentUserId, char *arrayOfTypeIds, int currentId);
 int fetchMaxValueFromHash(GHashTable *tempSortHash, int currentId);
 int drawTrackTitle(gdImagePtr im, int initialHeight, myTrack *localTrack);
 myTrackUrlInfo *createTrackUrlInfo(void);
 myTrackUrlInfo *getTrackURLCheckingAllDatabases(char *fmethodFsource);
 myTrackUrlInfo *createDefaultTrackInfo(char *fmethod, char *fsource, int isHighDens);
 myTrackUrlInfo *fillTrackURL(char *databaseName, int ftypeid);
 char *stripRegExPattern(char *pattern, const char *subject, int subject_length, int compiled_options);
 char *stripHtmlTags(char *value);
 char *returnFirstLine(char *paragraph);
 void setDisplayTrackDescriptions(int NoYes);
 int getDisplayTrackDescriptions(void);
 char **returnRegExMatch(char *pattern, const char *subject, int options, int *numberOfString);
 char *appendMaxMinBinToQuery(int currentDatabase, char *baseQuery);
 void sequence_drawGD(gdImagePtr im, myGroup *theGroup, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor);
 char *getTrackBlackList(int databaseId);
 void setDBTrackAccessControl(void);
 void setTypeId2PermissionHash(void);
 int hasDBTrackAccessControl(int databaseId);
 int *whichFtypeIdsHaveAccessControl(int databaseId);
 int doIHaveAccessToTrack(int databaseId, int ftypeId);
 GHashTable *getTypeId2PermissionHash(void);
 int calculateStart(long start, int special);
 int calculateEnd(long rawStart, long start, long end, int special);
 void printNameOfAnnotation(gdImagePtr im, int visibility, char *name, int b_end, int hight, int color, int currentLevel);
 int returnEndOfText(int visibility, char *name, int b_end, int currentLevel);
 char *getEncodeSchema(void);
 void setEncodeSchema(int encodePref);
 void deleteGroup(myGroup *localmyGroup);
 void deleteListGroups(myGroup *localmyGroup);
 void deleteListAnnotations(myAnnotations *localAnnotation);
 void deleteAnnotation(myAnnotations *localAnnotation);
 void deleteTrack(myTrack *localTrack);
 void deleteTrackUrlInfo(myTrackUrlInfo *localTrackInfo);
 long *longdup(long numb);
 int *intdup(int numb);
 void eraseGroup(gpointer data);
 void eraseTrack(gpointer data);
 char **getTags(void);
 void print_entry(gpointer key, gpointer val, gpointer data);
 void print_entry_with_intValues(gpointer key, gpointer val, gpointer data);
 void print_entry_with_intKeys(gpointer key, gpointer val, gpointer data);
 gint compare_intPointers(gconstpointer  a, gconstpointer  b);
 gint compare_stringPointers(gconstpointer  c1,  gconstpointer c2);
 char **getArrayFromNumericSortedHashes(GHashTable *sortedHash, int *sortedCounter);
 char **getArrayFromStringHashes(GHashTable *unSortedStingHash, int *sortedCounter);
 arrayOfStrings *createArrayOfStrings(char **arrayString, int numberOfStrings);
 void setFtypeid2AttributeHash(void);
 GHashTable *getFtypeid2AttributeHash(void);
 void setFtypeid2AttributeDisplayHash(void);
 GHashTable *getFtypeid2AttributeDisplayHash(void);
 char *getValueFromFtypeAttrValueId(int databaseIndex, int ftypeAttrValue_id, long limit);
 char *getFtypeAttNameFromNameId(int databaseIndex, int ftypeAttrName_id);
 void eraseGlistWithAttValues(gpointer data);
 void eraseDoubleHash(gpointer data);
 void deleteTrackAttDisplays(trackAttDisplays *localAttDisplays);
 void eraseTrackAttDisplays(gpointer data);
 void fillFtypeAttrDisplay(void);
 void fillFtype2Attributes(void);
 void printTracksVPs(gdImagePtr im, int y, myTrack *ptrTrack);
 void printUsingTTFonts(gdImagePtr im, int y);
 trackAttDisplays *makeTrackAttDisplays(char *ftypeAttrName_id, char *valueId, char *color, int rank, int flags, int databaseIndexId, int userId);
 void deleteTrackAttDisplays(trackAttDisplays *localAttDisplays);
 void eraseTrackAttDisplays(gpointer data);
 char *trimmedText(char *originalText, int maxSize);
 int getSizeNeededByTrackAttributes(myTrack *ptrTrack);
 gint rankTrackAttr(gconstpointer a, gconstpointer b);
 void updateTrackAttDisplays(trackAttDisplays *localAttDisplays, char *ftypeAttrName_id, char *valueId, char *color, int rank, int flags, int databaseIndexId,int userId);
 void setGenomicFileNameWithExtension(char *extension);
 int getNumberStaticLinks(void);
 void setNumberStaticLinks(char *staticLinks);
 void makeImageMapForStaticTracks(char *trackName, int initialHeight, int hightOfTrack);
 void drawScoreLables(gdImagePtr im, int initialHeight, float maxScore, float minScore, int trackHeight, int isLogarithmic);
 void wigLarge_drawGD(gdImagePtr im, myTrack *localTrack, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, float minScore, int allocatedUpperColor, int allocatedLowerColor);
 void bidirectional_drawGD(gdImagePtr im, myTrack *localTrack, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, float minScore, int allocatedUpperColor, int allocatedLowerColor, int negativeColor, int allocatedUpperNegativeColor, int allocatedLowerNegativeColor);
 void bidirectional_drawGD_nonHighDensityTracks(gdImagePtr im, myTrack *localTrack, int visibility, int *multicolor, int initialHeight, int theHeight, int allocatedColor, float maxScore, float minScore, int allocatedUpperColor, int allocatedLowerColor, int negativeColor, int allocatedUpperNegativeColor, int allocatedLowerNegativeColor, myGroup * theGroup);
 void setStaticBufferSize(long myBuffer);
 long getStaticBufferSize(void);
 void setMaxNumberOfElementsToProcess(int dataSpan);
 void setBufferToReadDoubles(double lowLimit, int newSize);
 gdouble *getCurrentBufferToReadDoubles(void);
 gdouble *getBufferToReadDoubles(double lowLimit, int alternativeStructSize);
 gdouble *getDefaultBufferToReadDoubles(void);
 char *getCurrentBufferToReadChars(void);
 char *getBufferToReadChars(int alternativeStructSize, int dataSpan);
 char *getDefaultBufferToReadChars(void);
 long getMaxNumberOfElementsToProcess(int dataSpan);
 GHashTable *getGbTrackVarsHash(void);
 void setGbTrackVarsHash(void);
 highDensFtypes *makeCopyOfHDHV(highDensFtypes *hdhvTrack);
 void deleteHighDensFtypes(highDensFtypes *localBlockLevel);
 highDensFtypes *makeHighDensFtypes(void);
 int populateHDTI(highDensFtypes *highDensityTrackInfo, char *ftypeAttName, char *ftypeAttValue);
 int printHighDensityTracks(highDensFtypes *hdhvTrack, FILE *fildes);
 int isTrackHighDensity(int databaseId, int ftypeId);
 highDensFtypes *fillUpHighDensFtypes(char *featureType);
 char **getGbTrackVars(void);
 int isHighDensityTrack(char *featureType);
 int returnftypeId(char *featureType, int *databaseId);
 char **getGbTrackRecordTypes(void);
 GHashTable *getGbTrackRecordTypesHash(void);
 void setGbTrackRecordTypesHash(void);
 void setBufferToReadValueOfAPixel(gdouble lowLimit);
 gdouble *getBufferToReadValueOfAPixel(gdouble lowLimit);
 gdouble *getCurrentBufferToReadValueOfAPixel(void);
 void setHasHighDensityTracks(int yesNo);
 int getHasHighDensityTracks(void);
 void setSizeOfElementsUsedToGetMaxNumElements(int value);
 int returnNumberOfSpansInRegion(long annotationLenght, int bpStep, int bpSpan, int *sizeOfFirstFragment, int *sizeOfFirstGap);
 int populatePixels(gdouble **pixelValueForHDT, gdouble **pixelExtras, gdouble *genomicValue, int pixelChar, int numberOfElements, int windowingMethod, double minData, double maxData);
 void setFileToFileHandlerHash(void);
 GHashTable *getFileToFileHandlerHash(void);
 int returnFileHandler(char *fileName, int flag);
 void closeFileHandlerHash(void);
 void destroyBufferToReadChars(void);
 void destroyBufferToReadDoubles(void);
 void destroyBufferToReadValueOfAPixel(void);
 void testGbTrackRecordCode(void);
 int populateMultiplePixels(gdouble **pixelVHDT, gdouble **pExtras, gdouble genomicValue, int pixelStart, int numberOfElements, int windowingMethod, double minData, double maxData);
 coordinates *makeCoordinates(void);
 void setCoordinates(void);
 coordinates *clearCoordinates(void);
 coordinates *getCoordinates(void);
 int getSizeOfElementsUsedToGetMaxNumElements(void);
 long getCurrentMaxNumberOfElementsToProcess(void);
 void setBufferToReadChars(int newSize, int dataSpan);
 void setFullPathToFile(void);
 char *getFullPathToFile(void);
 void setBasesPerPixel(void);
 void destroyGetLinkInfoHash(void);
 char *getTagName();
 char *returnMap(char *filename, int *filePointer);
 int dropMap(char *fileBase, int filePointer);
 int returnNumberVisTagsOccurances(char *tag, char *fileBase, int totalLen);
 int returnTracksUsed(char *tag, char *fileBase, int totalLen);
 TVIS *createTVISfromXML(int numberOfOccurances);
 void counterStart(void *data, const char *el, const char **attr);
 void destroy_double_Local_pointer(char **ptr, int max_hits);
 void destroyLocalTvis(TVIS *tvis) ;
 void destroyAllVisibility(void);
 void end(void *data, const char *el);
 void fillStyleFeatures(int tracknumber, int nameId, char *value);
 void startStyleParsing(void *data, const char *el, const char **attr);
 void eraseFtypeIdsStatementByDatabaseId(void);
 void destroyTypeIdHash(void);
 void destroyAllHashesInHashManager(void);
 void destroyAllHashesInHDManager(void);
 void generateVisDataFromXml(char *xmlFileName);
 void setUniversalScaleGlobalForHDTrack(double myScale);
 void setStartPositionGlobalForHDTrack(long long start);
 void setEndPositionGlobalForHDTrack(long long end);
 void setCanvasWidthGlobalForHDTrack(int myWidth);
 void setTotalWidthGlobalForDrawingFunction(int width);
 void setLabelWidthGlobalForDrawingFunction(int width);
 void setStartPositionGlobalForDrawingFunction(long long start);
 void setEndPositionGlobalForDrawingFunction(long long end);
 void setEndPositionGlobalForDrawingFunction(long long end);
 void setCanvasWidthGlobalForDrawingFunction(int myWidth);
 void setUniversalScaleGlobalForDrawingFunction(double myScale);
 void setUniversalScaleGlobal(double myScale);
 void setUniversalScaleGlobal(double myScale);
 void setTotalWidthGlobal(int width);
 void setStartPositionGloblal(long long start);
 void setEndPositionGloblal(long long end);
 void setCanvasWidthGlobal(int myWidth);
 long long getStartPosition(void);
 gdouble getBasesPerPixel(void);
 void setLengthOfSegmentGlobal(long long length);
 void setLengthOfSegmentGlobalForDrawingFunction(long long length);
 void setLengthOfSegmentGlobalForHDTrack(long long length);
 int *getTrackIdsForHighDensityTracks(int databaseId, int *numberOfHighDensityTracks);
 void setFileId2FileNameHash(void);
 GHashTable *getFileId2FileNameHash(void);
 void deleteBlockLevelDataInfo(blockLevelDataInfo *dataInfo);
 void eraseBlockLevelDataInfo(gpointer data);
 void setFids2BlockLevelDataInfoHash(void);
 GHashTable *getFids2BlockLevelDataInfoHash(void);
 blockLevelDataInfo *makeBlockLevelDataInfo(unsigned long fid, int fileId, unsigned long offset, int gbBlockBpSpan, int gbBlockBpStep, int gbBlockScale, int gbBlockLowLimit, int numRecords);
 char *getInStatementForHighDensityTracks(int databaseToUse);
 char *returnQueryForFillBlockLevelData(int databaseId);
 char *altReturnInStatementWithAListOfFids(int databaseId, char *sqlbuff, int initialLine, int limit);
 void startTimers(void);
 void stopTimers(void);
 void addBlockLevelDataInfoToAnnotations(myTrack *localTrack, GHashTable *fid2BlockHash);
 highDensFtypes *getBlockLevelDataInfo(highDensFtypes *hdhvTrack, blockLevelDataInfo *currentBlockLevelDataInfo);
 void processHighDensityBlocks(myTrack *localTrack);
 int getSizeOfListOfFids(myTrack *localTrack, int *numOfRec);
 int returnInStatementWithAListOfFids(myTrack *localTrack, int initialLine, int limit, char **stringToUse, int numberOfRecords);
 inline void concatenateString(char *destination, char *source);
 char *addFullPathToFile(char *fileName, char *pathName);
 void readAnnotationsFromFilePointer(int fd, char **addressOfBlocksToRead, int numberOfElements, int sizeOfElements, off64_t seekTo);
 int returnFileHandlerUsingSha1(char *fileName, int flag);
 void deleteDbHost(void);
 void deleteGenboreeUserNameAndPassWord(void);
 char **splitLargeStringIntoSubstringsUsingSeparator(const char *list, const char *selectedSeparator, int *numberOfResults);
 char *getInStatementForRegularTracks(int databaseToUse);
 int fillBlockLevelDataInfo(myTrack *localTrack);
 void deleteBuffers(void);
 myTrack *returnTrackFromDatabaseIdTypeId(int databaseId, int typeId);
 void addHDAnnotationToPixelMap(gdouble *pixelValueForHDT, gdouble *pixelExtras, gdouble *pixelNegativeValueForHDT, gdouble *pixelNegativeExtras, int fileHandler, off_t fileSize, char *theStyle);
 void fillStaticBuffer(int fd, off64_t offset, off_t fileSize);
 char *returnAnnotationsFromFilePointer(int fd, int numberOfElements, int sizeOfElements, off64_t seekTo, off_t fileSize);
 int fillDataHDHV(minHighDensFtype minimumHDInfo, unsigned long fid, int fileId, unsigned long offset, int gbBlockBpSpan, int gbBlockBpStep, int gbBlockScale, int gbBlockLowLimit, int numRecords, long annotationStart, long annotationStop, long byteLength);
 inline void updatePixelStruct(long currentLocation, int canvasSize);
 inline void updatePixelValue(long firstPixel, long lastPixel, int windowingMethod, double currentValue, double *pixelValueForHDT, double *pixelExtras);
 int getZoomLevels(myTrack *localTrack);
 int getMaxZoomLevels(gdouble bpPerPixel, myTrack * localTrack);
 int getAvgZoomLevels(gdouble bpPerPixel, myTrack * localTrack);
 int getMinZoomLevels(gdouble bpPerPixel, myTrack * localTrack);
 void key_destroyed(gpointer data) ;
 void updateTrackInfoHash(int userId, char *databaseName) ;
#endif /* _optimizedFunctions_h */
