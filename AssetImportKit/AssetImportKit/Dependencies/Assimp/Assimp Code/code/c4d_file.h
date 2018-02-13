/////////////////////////////////////////////////////////////
// MELANGE SDK                                             //
/////////////////////////////////////////////////////////////
// (c) MAXON Computer GmbH, all rights reserved            //
/////////////////////////////////////////////////////////////

#ifndef C4D_FILE_H__
#define C4D_FILE_H__

/// @defgroup group_enumeration Enumeration

/// @defgroup group_topic Topic

/// @defgroup group_miscellaneous Miscellaneous

/// @defgroup group_customguisettings Custom GUI Settings

#if !defined(MAXON_TARGET_OSX) && !defined(MAXON_TARGET_IOS) && !defined MAXON_TARGET_LINUX
	#pragma warning(disable:4355)
#endif

#include "c4d_baselink.h"
#include "c4d_system.h"
#include "c4d_tools.h"
#include "customgui_gradient.h"
#include "customgui_datetime.h"
#include "customgui_splinecontrol.h"
#include "customgui_unitscale.h"
#include "blenddatatype.h"
#include "customdatatype_realarray.h"
#include "customgui_lensglow.h"
#include "customgui_matpreview.h"
#include "customgui_listview.h"
#include "customdatatype_itemlist.h"
#include "customdatatype_itemtree.h"
#include "customdatatype_skyobjects.h"
#include "customdatatype_spreadsheet.h"
#include "customdatatype_pla.h"
#include "customdatatype_dynamicsplinedata.h"
#include "customdatatype_colorprofile.h"
#include "customgui_inexclude.h"
#include "customgui_range.h"
#include "private_ge_thread.h"
#include "c4d_quaternion.h"
#include "basearray.h"
#include "c4d_baselinkarray.h"
#include "private_reflectionmain.h"
#include "private_reflectiondata.h"
#include "sort.h"
#include "c4d_baselinkarray.h"
#include "customgui_fontchooser.h"
#include "c4d_basecontainer.h"
#include "c4d_cpolygon.h"

#include "c4d_nodedata.h"
#include "c4d_rootmaterial.h"
#include "c4d_rootobject.h"
#include "c4d_rootlayer.h"
#include "c4d_rootrenderdata.h"
#include "c4d_layerobject.h"
#include "c4d_rootviewpanel.h"

namespace melange
{
#pragma pack (push, 8)

class NodeData;
class BaseObject;
class BaseMaterial;
class BaseTag;
class LayerObject;
class BaseShader;
class NodeData;
class CTrack;
class RenderData;
class PgonEdge;
class IESLight;
class SplineData;
class PolygonObject;
class ItemTreeNode;
class ItemTreeData;
class LocalFileTime;
class CKey;
struct LayerData;
class BaseSceneHook;
class TakeData;
class BaseTakeData;
class BaseOverride;
class SubOverride;
struct OverrideDataSet;
class OverrideEntry;
class RootPluginNode;
class RootList2D;
class TakeSystemHook;
class InExcludeData;

/// @addtogroup group_c4d_file_globalfunctions Global Functions
/// @ingroup group_topic Topics
/// @{

//----------------------------------------------------------------------------------------
/// Retrieves the Melange SDK version.
/// @return The Melange SDK version as a String.
//----------------------------------------------------------------------------------------
String GetLibraryVersion();

//----------------------------------------------------------------------------------------
/// Retrieves only the version number of the Melange SDK.
/// @return The Melange SDK version number as a string.
//----------------------------------------------------------------------------------------
String GetLibraryVersionShort();

/// @}

/// @addtogroup group_c4d_file_document Document
/// @ingroup group_topic Topics
/// @{

//----------------------------------------------------------------------------------------
/// Loads a document.
/// @param[in] name								File to load the document from.@callerOwnsPointed{document}
/// @param[in] loadflags					Flags for the load.
/// @return												The document that was loaded, or @formatConstant{nullptr} if it failed.
//----------------------------------------------------------------------------------------
BaseDocument* LoadDocument(const Filename& name, SCENEFILTER loadflags);

//----------------------------------------------------------------------------------------
/// Merges the file @formatParam{name} with the document @formatParam{doc}.
/// @param[in] doc								The document to merge the loaded scene into. @callerOwnsPointed{document}
/// @param[in] name								File to load the merge document from.
/// @param[in] loadflags					Flags for the load.
/// @return												Success of mering.
//----------------------------------------------------------------------------------------
Bool MergeDocument(BaseDocument* doc, const Filename& name, SCENEFILTER loadflags);

//----------------------------------------------------------------------------------------
/// Saves a document to a file.
/// @param[in] doc								The document to save to a file. @callerOwnsPointed{document}
/// @param[in] name								File to save the document to.
/// @param[in] saveflags					Flags for the save.
/// @return												Success of saving.
//----------------------------------------------------------------------------------------
Bool SaveDocument(BaseDocument* doc, const Filename& name, SAVEDOCUMENTFLAGS saveflags);

//----------------------------------------------------------------------------------------
/// Retrieves the first timeline marker of the document.
/// @since 17.008
/// @param[in] doc								The document. @callerOwnsPointed{document}
/// @return												The first timeline marker. @melangeOwnsPointed{marker}
//----------------------------------------------------------------------------------------
BaseList2D* GetFirstMarker(BaseDocument* doc);

//----------------------------------------------------------------------------------------
/// Inserts a timeline marker into the document at a given time.\n
/// Optionally an insertion point @formatParam{pPred} in the timeline marker list can be specified, giving the marker before the wanted insertion point.
/// @since 17.008
/// @param[in] doc								The document. @callerOwnsPointed{document}
/// @param[in] pPred							The optional timeline marker to use as list insertion point. @callerOwnsPointed{marker}
/// @param[in] time								The time position of the timeline marker.
/// @param[in] name								The name of the timeline marker.
/// @return												The added timeline marker, or @formatConstant{nullptr} if insertion failed.
//----------------------------------------------------------------------------------------
BaseList2D* AddMarker(BaseDocument* doc, BaseList2D* pPred, BaseTime time, String name);

/// @}

//----------------------------------------------------------------------------------------
/// Gets a user presentable name for an object type ID.\n
/// For example @c GetObjectName(Onull) returns @em "Null".
/// @param[in] id									An object type ID.
/// @return												The object type name for @formatParam{id}.
//----------------------------------------------------------------------------------------
const Char* GetObjectTypeName(Int32 id);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadMemoryVectorArray(HyperFile* hf, Vector** pData, Int32* lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadMemoryRealArray(HyperFile* hf, Float** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const Vector* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, Vector** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const Float64* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, Float64** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const Float32* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, Float32** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const UChar* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, UChar** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const Int32* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, Int32** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const Int16* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, Int16** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFWriteArray(HyperFile* hf, const UInt16* pData, Int32 lCount);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadArray(HyperFile* hf, UInt16** pData, Int32* lCount);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadMemoryL(HyperFile* hf, void** data, Int* count);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool _HFReadMemoryW(HyperFile* hf, void** data, Int* count);

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool WriteSelectBlock(HyperFile* hf, SelectBlockArray* sel);
//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
Bool ReadSelectBlock(HyperFile* hf, SelectBlockArray* sel);
//----------------------------------------------------------------------------------------

/// @addtogroup group_localtime Local Time
/// @ingroup group_topic
/// @{

/// @addtogroup GE_FILETIME
/// @ingroup group_enumeration
/// @{
/// @see GeGetFileTime()
#define	GE_FILETIME_CREATED	 0	/// File time created.
#define	GE_FILETIME_MODIFIED 1	/// File time modified.
#define	GE_FILETIME_ACCESS	 2	/// File time accessed.
/// @}

//----------------------------------------------------------------------------------------
/// Gets a file time for the given @formatParam{mode}.
/// @param[in] name								File name to get the time for.
/// @param[in] mode								Time mode: @ref GE_FILETIME.
/// @param[out] out								Filled with the file time.
/// @return												@trueIfOtherwiseFalse{the file time could be retrieved}
//----------------------------------------------------------------------------------------
Bool GeGetFileTime(const Filename& name, Int32 mode, LocalFileTime* out);

//----------------------------------------------------------------------------------------
/// Gets the current time.
/// @param[out] out								Filled with the current time.
//----------------------------------------------------------------------------------------
void GeGetCurrentTime(LocalFileTime* out);

class LocalFileTime
{
public:
	UInt16 year;		///< Year. (Actual year, e.g. @em 2005 A.D. = @em 2005.)
	UInt16 month;		///< Month. (Actual month, e.g. September = @em 9.)
	UInt16 day;			///< Day. (Actual day, e.g. @em 30 = @em 30.)
	UInt16 hour;		///< Actual hour. (Between 0 and 23. @em 4 pm = @em 16.)
	UInt16 minute;	///< Actual minute. (Between 0 and 59.)
	UInt16 second;	///< Actual second. (Between 0 and 59.)

	//----------------------------------------------------------------------------------------
	/// Initializes the file time to a possibly invalid but deterministic state (0000-00-00 00:00:00).
	//----------------------------------------------------------------------------------------
	void Init(void)
	{
		year = month = day = hour = minute = second = 0;
	}

	//----------------------------------------------------------------------------------------
	/// Compares the two times @formatParam{t0} and @formatParam{t1}.
	/// @param[in] t0									File time to compare.
	/// @param[in] t1									File time to compare.
	/// @return												@em 0 if the times are identical. < @em 0 if @formatParam{t0} is before @formatParam{t1}, or > @em 0 if @formatParam{t0} is after @formatParam{t1}.
	//----------------------------------------------------------------------------------------
	Int32 Compare(const LocalFileTime& t0, const LocalFileTime& t1)
	{
		Int32 result;

		result = t0.year - t1.year;
		if (result == 0)
		{
			result = t0.month - t1.month;
			if (result == 0)
			{
				result = t0.day - t1.day;
				if (result == 0)
				{
					result = t0.hour - t1.hour;
					if (result == 0)
					{
						result = t0.minute - t1.minute;
						if (result == 0)
							result = t0.second - t1.second;
					}
				}
			}
		}
		return result;
	}

	//----------------------------------------------------------------------------------------
	/// Equality operator. Checks if the file time is the same as another.
	/// @param[in] x									File time to check equality with.
	//----------------------------------------------------------------------------------------
	Bool operator == (const LocalFileTime& x)
	{
		return year == x.year && month == x.month && day == x.day && hour == x.hour && minute == x.minute && second == x.second;
	}

	//----------------------------------------------------------------------------------------
	/// Inequality operator. Checks if the file time is different to another.
	/// @param[in] x									File time to compare with.
	//----------------------------------------------------------------------------------------
	Bool operator != (const LocalFileTime& x)
	{
		return year != x.year || month != x.month || day != x.day || hour != x.hour || minute != x.minute || second != x.second;
	}

	//----------------------------------------------------------------------------------------
	/// Greater than operator. Checks if the file time is greater than another.
	/// @param[in] x									File time to compare with.
	//----------------------------------------------------------------------------------------
	Bool operator > (const LocalFileTime& x)
	{
		return Compare(*this, x) > 0;
	}

	//----------------------------------------------------------------------------------------
	/// Less than operator. Checks if the file time is lower than another.
	/// @param[in] x									File time to compare with.
	//----------------------------------------------------------------------------------------
	Bool operator < (const LocalFileTime& x)
	{
		return Compare(*this, x) < 0;
	}

	//----------------------------------------------------------------------------------------
	/// Greater than or equal to operator. Checks if the file time is greater or equal than another.
	/// @param[in] x									File time to compare with.
	//----------------------------------------------------------------------------------------
	Bool operator >= (const LocalFileTime& x)
	{
		return Compare(*this, x) >= 0;
	}

	//----------------------------------------------------------------------------------------
	/// Less than or equal operator. Checks if the file time is lower or equal than another.
	/// @param[in] x									File time to compare with.
	//----------------------------------------------------------------------------------------
	Bool operator <= (const LocalFileTime& x)
	{
		return Compare(*this, x) <= 0;
	}

	//----------------------------------------------------------------------------------------
	/// Minus operator. Subtracts one time from another.
	/// @since R19
	/// @param[in] t									File time to subtract from.
	//----------------------------------------------------------------------------------------
	LocalFileTime operator - (const LocalFileTime& t) const
	{
		LocalFileTime resTime;
		resTime.Init();

		Int16 resTime_hour = hour - t.hour;
		Int16 resTime_minute = minute - t.minute;
		Int16 resTime_second = second - t.second;
		Int16 resTime_month	 = month - t.month;
		Int16 resTime_year = year - t.year;
		Int16 resTime_day	 = day - t.day;

		if (resTime_second < 0)
		{
			resTime_second += 60;
			resTime_minute--;
		}

		if (resTime_minute < 0)
		{
			resTime_minute += 60;
			resTime_hour--;
		}

		if (resTime_hour < 0)
		{
			resTime_hour += 24;
			resTime_day--;
		}

		if (resTime_day < 0)
		{
			resTime_day = -30;	// ???
			resTime_month--;
		}

		if (resTime_month < 0)
		{
			resTime_month += 12;
			resTime_year--;
		}

		resTime.hour		= (UInt16)resTime_hour;
		resTime.minute	= (UInt16)resTime_minute;
		resTime.second	= (UInt16)resTime_second;
		resTime.month		= (UInt16)resTime_month;
		resTime.year		= (UInt16)resTime_year;
		resTime.day			= (UInt16)resTime_day;

		return resTime;
	}
};

/// @}

// HELPER
#define HFWRITE_ERROR(hf)				{ hf->SetError(FILEERROR_WRITE); return false; }
#define HFWRITE_ERROR_NOMEM(hf) { hf->SetError(FILEERROR_OUTOFMEMORY); return false; }

#pragma pack (pop)
}

#endif	// C4D_FILE_H__
