/////////////////////////////////////////////////////////////
// MELANGE SDK                                             //
/////////////////////////////////////////////////////////////
// (c) MAXON Computer GmbH, all rights reserved            //
/////////////////////////////////////////////////////////////

#ifndef DEFAULT_ALIEN_OVERLOADS_H__
#define DEFAULT_ALIEN_OVERLOADS_H__

#include "c4d.h"

#ifndef DONT_INCLUDE_MEMORY_OVERLOADS

// Default "alien" and memory function overloads.
// Use this code in your project and modify it to your purposes.
// At least make sure to overload GetWriterInfo() and return your own unique application ID.

namespace melange
{
#pragma pack (push, 8)

///////////////////////////////////////////////////////////////////////////////////////////////////

/// Memory allocation functions.
/// Overload MemAlloc() / MemFree() for custom memory management.

void* MemAllocNC(Int size)
{
	void* mem = malloc(size);
	return mem;
}

void* MemAlloc(Int size)
{
	void* mem = MemAllocNC(size);
	if (!mem)
		return nullptr;
	memset(mem, 0, size);
	return mem;
}

void* MemRealloc(void* orimem, Int size)
{
	void* mem = realloc(orimem, size);
	return mem;
}

void MemFree(void*& mem)
{
	if (!mem)
		return;

	free(mem);
	mem = nullptr;
}

#pragma pack (pop)
}

#endif	// DONT_INCLUDE_MEMORY_OVERLOADS

///////////////////////////////////////////////////////////////////////////////////////////////////

/// @addtogroup group_alienimplementatation Alien Alloc() Implementation
/// @ingroup group_topic Topics
/// @{

//----------------------------------------------------------------------------------------
/// Allocates the document root for the material.
/// @return												The "alien" root material.
//----------------------------------------------------------------------------------------
melange::RootMaterial* AllocAlienRootMaterial()
{
	return NewObj(melange::RootMaterial);
}

//----------------------------------------------------------------------------------------
/// Allocates the document root for the object.
/// @return												The "alien" root object.
//----------------------------------------------------------------------------------------
melange::RootObject* AllocAlienRootObject()
{
	return NewObj(melange::RootObject);
}

//----------------------------------------------------------------------------------------
/// Allocates the document root for the layer.
/// @return												The "alien" root layer.
//----------------------------------------------------------------------------------------
melange::RootLayer* AllocAlienRootLayer()
{
	return NewObj(melange::RootLayer);
}

//----------------------------------------------------------------------------------------
/// Allocates the document root for the render data.
/// @return												The "alien" root render data.
//----------------------------------------------------------------------------------------
melange::RootRenderData* AllocAlienRootRenderData()
{
	return NewObj(melange::RootRenderData);
}

//----------------------------------------------------------------------------------------
/// @markPrivate
//----------------------------------------------------------------------------------------
melange::RootViewPanel* AllocC4DRootViewPanel()
{
	return NewObj(melange::RootViewPanel);
}

//----------------------------------------------------------------------------------------
/// Allocates a layer.
/// @return												A "alien" layer.
//----------------------------------------------------------------------------------------
melange::LayerObject* AllocAlienLayer()
{
	return NewObj(melange::LayerObject);
}

/// @}

///////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------------------
/// Allocates the object types.
/// @param[in] id									The object data ID to allocate.
/// @param[out] known							Assign @formatConstant{false} to tell @MELANGE the object data ID is known.
/// @param[in] node								The parent node the data gets assigned to. @melangeOwnsPointed{node} Since R19.
/// @return												The allocated object node data.
//----------------------------------------------------------------------------------------
melange::NodeData* AllocAlienObjectData(melange::Int32 id, melange::Bool& known, melange::BaseList2D* node)
{
	melange::NodeData* m_data = nullptr;
	known = true;
	switch (id)
	{
		case Ocamera:
			m_data = NewObj(melange::CameraObjectData);
			break;
		case Olight:
			m_data = NewObj(melange::LightObjectData);
			break;
		case Opolygon:
			m_data = NewObj(melange::PolygonObjectData);
			break;
		case Olod:
			m_data = NewObj(melange::LodObjectData);
			break;

		case Osphere:	// Fall through all
		case Ocube:
		case Oplane:
		case Ocone:
		case Otorus:
		case Ocylinder:
		case Opyramid:
		case Oplatonic:
		case Odisc:
		case Otube:
		case Ofigure:
		case Ofractal:
		case Ocapsule:
		case Ooiltank:
		case Orelief:
		case Osinglepoly:
			m_data = NewObj(melange::NodeData);
			break;

		case Obend:	// Fall through all
		case Otwist:
		case Obulge:
		case Oshear:
		case Otaper:
		case Obone:
		case Oformula:
		case Owind:
		case Oexplosion:
		case Oexplosionfx:
		case Omelt:
		case Oshatter:
		case Owinddeform:
		case Opolyreduction:
		case Ospherify:
		case Osplinedeformer:
		case Osplinerail:
			m_data = NewObj(melange::NodeData);
			break;

		case Offd:
			m_data = NewObj(melange::PointObjectData);
			break;

		case Onull:
			m_data = NewObj(melange::NodeData);
			break;
		case Ofloor:
			m_data = NewObj(melange::NodeData);
			break;
		case Oforeground:
			m_data = NewObj(melange::NodeData);
			break;
		case Obackground:
			m_data = NewObj(melange::NodeData);
			break;
		case Osky:
			m_data = NewObj(melange::NodeData);
			break;
		case Oenvironment:
			m_data = NewObj(melange::NodeData);
			break;
		case Oinstance:
			m_data = NewObj(melange::NodeData);
			break;
		case Oboole:
			m_data = NewObj(melange::NodeData);
			break;
		case Oextrude:
			m_data = NewObj(melange::NodeData);
			break;

		case Oxref:
			m_data = NewObj(melange::NodeData);
			break;
		case SKY_II_SKY_OBJECT:
			m_data = NewObj(melange::SkyShaderObjectData);
			break;
		case Ocloud:
			m_data = NewObj(melange::CloudData);
			break;
		case Ocloudgroup:
			m_data = NewObj(melange::CloudGroupData);
			break;
		case Ojoint:
			m_data = NewObj(melange::JointObjectData);
			break;
		case Oskin:
			m_data = NewObj(melange::SkinObjectData);
			break;
		case CA_MESH_DEFORMER_OBJECT_ID:
			m_data = NewObj(melange::MeshDeformerObjectData);
			break;
		default:
			known = false;
			break;
	}

	return m_data;
}

//
//----------------------------------------------------------------------------------------
/// Allocates the tag types.
/// @param[in] id									The tag data ID to allocate.
/// @param[out] known							Assign @formatConstant{false} to tell @MELANGE the tag data ID is known.
/// @param[in] node								The parent node the data gets assigned to. @melangeOwnsPointed{node} Since R19.
/// @return												The allocated tag node data.
//----------------------------------------------------------------------------------------
melange::NodeData* AllocAlienTagData(melange::Int32 id, melange::Bool& known, melange::BaseList2D* node)
{
	melange::NodeData* m_data = nullptr;
	known = true;
	switch (id)
	{
		case Tweights:
			m_data = melange::WeightTagData::Alloc();
			break;
		case Thairlight:
			m_data = melange::HairLightTagData::Alloc();
			break;
		case Tsds:
			m_data = melange::HNWeightTagData::Alloc();
			break;
		default:
			known = false;
			break;
	}

	return m_data;
}

//
//----------------------------------------------------------------------------------------
/// Allocates the shader types.
/// @param[in] id									The shader data ID to allocate.
/// @param[out] known							Assign @formatConstant{false} to tell @MELANGE the shader data ID is known.
/// @param[in] node								The parent node the data gets assigned to. @melangeOwnsPointed{node} Since R19.
/// @return												The allocated shader node data.
//----------------------------------------------------------------------------------------
melange::NodeData* AllocAlienShaderData(melange::Int32 id, melange::Bool& known, melange::BaseList2D* node)
{
	melange::NodeData* m_data = nullptr;
	known = true;
	switch (id)
	{
		case Xvariation:
			m_data = melange::VariationShaderData::Alloc();
			break;
		default:
			known = false;
			break;
	}

	return m_data;
}

/// @}

///////////////////////////////////////////////////////////////////////////////////////////////////

melange::Bool melange::BaseDocument::CreateSceneToC4D(melange::Bool selectedOnly)
{
	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#endif	// DEFAULT_ALIEN_OVERLOADS_H__
