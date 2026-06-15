#ifndef RATHENA_MAP_COLLECTION_HPP
#define RATHENA_MAP_COLLECTION_HPP

#include <vector>
#include <string>
#include <memory>
#include "common/database.hpp"
#include "common/mmo.hpp"
#include "script.hpp"

struct s_collection_req {
	t_itemid nameid;
	int32 amount;
};

struct s_collection_db {
	uint32 id;
	std::string name;
	uint8 type; // 0 = Account Wide, 1 = Character Bound
	std::vector<s_collection_req> req_items;
	struct script_code* bonus_script;

	// --- 🛡️ แทรก Destructor อุดรอยรั่ว Memory Leak ตรงนี้ ---
	~s_collection_db() {
		if (bonus_script) {
			script_free_code(bonus_script);
			bonus_script = nullptr;
		}
	}
	// ---------------------------------------------------
};

class CollectionDatabase : public TypesafeYamlDatabase<uint32, s_collection_db> {
public:
	CollectionDatabase() : TypesafeYamlDatabase("COLLECTION_DB", 1) {}
	const std::string getDefaultLocation() override { return "db/import/collection.yml"; }
	uint64 parseBodyNode(const ryml::NodeRef& node) override;
};

extern CollectionDatabase collection_db;

#endif /* RATHENA_MAP_COLLECTION_HPP */