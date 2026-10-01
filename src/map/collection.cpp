#include "collection.hpp"
#include "itemdb.hpp"
#include "common/showmsg.hpp"

CollectionDatabase collection_db;

uint64 CollectionDatabase::parseBodyNode(const ryml::NodeRef& node) {
	uint32 id;
	if (!this->asUInt32(node, "Id", id)) return 0;

	std::shared_ptr<s_collection_db> entry = std::make_shared<s_collection_db>();
	entry->id = id;
	this->asString(node, "Name", entry->name);
	
	uint16 type = 0;
	this->asUInt16(node, "Type", type);
	entry->type = static_cast<uint8>(type);

	if (this->nodeExists(node, "Items")) {
		for (const auto& itemNode : node["Items"]) {
			s_collection_req req;
			std::string itemName;
			this->asString(itemNode, "Item", itemName);
			
			std::shared_ptr<item_data> it = nullptr;

			// รองรับทั้งการใส่ Item ID (ตัวเลข) และ AegisName (ตัวหนังสือ) ในไฟล์ YAML
			if (ISDIGIT(itemName[0])) {
				it = item_db.find(std::stoul(itemName));
			} else {
				it = item_db.search_aegisname(itemName.c_str());
			}

			if (it != nullptr) {
				req.nameid = it->nameid;
				this->asInt32(itemNode, "Amount", req.amount);
				entry->req_items.push_back(req);
			// 🛠️ ปลดล็อกรอยรั่วระบบเดิม: บังคับเปิดสถานะคอลเล็คชันให้ไอเทมที่อยู่ในไฟล์ YAML ทันที
				it->flag.collection = true; 
			} else {
				ShowWarning("CollectionDatabase: Item '%s' not found.\n", itemName.c_str());
			}
		}
	}

	if (this->nodeExists(node, "Script")) {
		std::string scriptStr;
		this->asString(node, "Script", scriptStr);
		entry->bonus_script = parse_script(scriptStr.c_str(), this->getCurrentFile().c_str(), this->getLineNumber(node["Script"]), SCRIPT_IGNORE_EXTERNAL_BRACKETS);
	} else {
		entry->bonus_script = nullptr;
	}

	this->put(id, entry);
	return 1;
}